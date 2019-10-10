
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: EventGridManagementClient
## version: 2018-01-01
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

  OpenApiRestCall_573642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573642): Option[Scheme] {.used.} =
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
  Call_OperationsList_573864 = ref object of OpenApiRestCall_573642
proc url_OperationsList_573866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573865(path: JsonNode; query: JsonNode;
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
  var valid_574025 = query.getOrDefault("api-version")
  valid_574025 = validateParameter(valid_574025, JString, required = true,
                                 default = nil)
  if valid_574025 != nil:
    section.add "api-version", valid_574025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574048: Call_OperationsList_573864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the available operations supported by the Microsoft.EventGrid resource provider
  ## 
  let valid = call_574048.validator(path, query, header, formData, body)
  let scheme = call_574048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574048.url(scheme.get, call_574048.host, call_574048.base,
                         call_574048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574048, url, valid)

proc call*(call_574119: Call_OperationsList_573864; apiVersion: string): Recallable =
  ## operationsList
  ## List the available operations supported by the Microsoft.EventGrid resource provider
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_574120 = newJObject()
  add(query_574120, "api-version", newJString(apiVersion))
  result = call_574119.call(nil, query_574120, nil, nil, nil)

var operationsList* = Call_OperationsList_573864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/operations",
    validator: validate_OperationsList_573865, base: "", url: url_OperationsList_573866,
    schemes: {Scheme.Https})
type
  Call_TopicTypesList_574160 = ref object of OpenApiRestCall_573642
proc url_TopicTypesList_574162(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TopicTypesList_574161(path: JsonNode; query: JsonNode;
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
  var valid_574163 = query.getOrDefault("api-version")
  valid_574163 = validateParameter(valid_574163, JString, required = true,
                                 default = nil)
  if valid_574163 != nil:
    section.add "api-version", valid_574163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574164: Call_TopicTypesList_574160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all registered topic types
  ## 
  let valid = call_574164.validator(path, query, header, formData, body)
  let scheme = call_574164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574164.url(scheme.get, call_574164.host, call_574164.base,
                         call_574164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574164, url, valid)

proc call*(call_574165: Call_TopicTypesList_574160; apiVersion: string): Recallable =
  ## topicTypesList
  ## List all registered topic types
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_574166 = newJObject()
  add(query_574166, "api-version", newJString(apiVersion))
  result = call_574165.call(nil, query_574166, nil, nil, nil)

var topicTypesList* = Call_TopicTypesList_574160(name: "topicTypesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/topicTypes",
    validator: validate_TopicTypesList_574161, base: "", url: url_TopicTypesList_574162,
    schemes: {Scheme.Https})
type
  Call_TopicTypesGet_574167 = ref object of OpenApiRestCall_573642
proc url_TopicTypesGet_574169(protocol: Scheme; host: string; base: string;
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

proc validate_TopicTypesGet_574168(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574184 = path.getOrDefault("topicTypeName")
  valid_574184 = validateParameter(valid_574184, JString, required = true,
                                 default = nil)
  if valid_574184 != nil:
    section.add "topicTypeName", valid_574184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574185 = query.getOrDefault("api-version")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "api-version", valid_574185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574186: Call_TopicTypesGet_574167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a topic type
  ## 
  let valid = call_574186.validator(path, query, header, formData, body)
  let scheme = call_574186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574186.url(scheme.get, call_574186.host, call_574186.base,
                         call_574186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574186, url, valid)

proc call*(call_574187: Call_TopicTypesGet_574167; topicTypeName: string;
          apiVersion: string): Recallable =
  ## topicTypesGet
  ## Get information about a topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_574188 = newJObject()
  var query_574189 = newJObject()
  add(path_574188, "topicTypeName", newJString(topicTypeName))
  add(query_574189, "api-version", newJString(apiVersion))
  result = call_574187.call(path_574188, query_574189, nil, nil, nil)

var topicTypesGet* = Call_TopicTypesGet_574167(name: "topicTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}",
    validator: validate_TopicTypesGet_574168, base: "", url: url_TopicTypesGet_574169,
    schemes: {Scheme.Https})
type
  Call_TopicTypesListEventTypes_574190 = ref object of OpenApiRestCall_573642
proc url_TopicTypesListEventTypes_574192(protocol: Scheme; host: string;
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

proc validate_TopicTypesListEventTypes_574191(path: JsonNode; query: JsonNode;
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
  var valid_574193 = path.getOrDefault("topicTypeName")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "topicTypeName", valid_574193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574194 = query.getOrDefault("api-version")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "api-version", valid_574194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574195: Call_TopicTypesListEventTypes_574190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic type
  ## 
  let valid = call_574195.validator(path, query, header, formData, body)
  let scheme = call_574195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574195.url(scheme.get, call_574195.host, call_574195.base,
                         call_574195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574195, url, valid)

proc call*(call_574196: Call_TopicTypesListEventTypes_574190;
          topicTypeName: string; apiVersion: string): Recallable =
  ## topicTypesListEventTypes
  ## List event types for a topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_574197 = newJObject()
  var query_574198 = newJObject()
  add(path_574197, "topicTypeName", newJString(topicTypeName))
  add(query_574198, "api-version", newJString(apiVersion))
  result = call_574196.call(path_574197, query_574198, nil, nil, nil)

var topicTypesListEventTypes* = Call_TopicTypesListEventTypes_574190(
    name: "topicTypesListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventTypes",
    validator: validate_TopicTypesListEventTypes_574191, base: "",
    url: url_TopicTypesListEventTypes_574192, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscription_574199 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListGlobalBySubscription_574201(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalBySubscription_574200(path: JsonNode;
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
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574203 = query.getOrDefault("api-version")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "api-version", valid_574203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574204: Call_EventSubscriptionsListGlobalBySubscription_574199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ## 
  let valid = call_574204.validator(path, query, header, formData, body)
  let scheme = call_574204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574204.url(scheme.get, call_574204.host, call_574204.base,
                         call_574204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574204, url, valid)

proc call*(call_574205: Call_EventSubscriptionsListGlobalBySubscription_574199;
          apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalBySubscription
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574206 = newJObject()
  var query_574207 = newJObject()
  add(query_574207, "api-version", newJString(apiVersion))
  add(path_574206, "subscriptionId", newJString(subscriptionId))
  result = call_574205.call(path_574206, query_574207, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscription* = Call_EventSubscriptionsListGlobalBySubscription_574199(
    name: "eventSubscriptionsListGlobalBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscription_574200,
    base: "", url: url_EventSubscriptionsListGlobalBySubscription_574201,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscription_574208 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListRegionalBySubscription_574210(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalBySubscription_574209(path: JsonNode;
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
  var valid_574211 = path.getOrDefault("subscriptionId")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "subscriptionId", valid_574211
  var valid_574212 = path.getOrDefault("location")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "location", valid_574212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574213 = query.getOrDefault("api-version")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "api-version", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_EventSubscriptionsListRegionalBySubscription_574208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_EventSubscriptionsListRegionalBySubscription_574208;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## eventSubscriptionsListRegionalBySubscription
  ## List all event subscriptions from the given location under a specific Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the location
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(query_574217, "api-version", newJString(apiVersion))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  add(path_574216, "location", newJString(location))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscription* = Call_EventSubscriptionsListRegionalBySubscription_574208(
    name: "eventSubscriptionsListRegionalBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalBySubscription_574209,
    base: "", url: url_EventSubscriptionsListRegionalBySubscription_574210,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_574218 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListRegionalBySubscriptionForTopicType_574220(
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

proc validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_574219(
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
  var valid_574221 = path.getOrDefault("topicTypeName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "topicTypeName", valid_574221
  var valid_574222 = path.getOrDefault("subscriptionId")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "subscriptionId", valid_574222
  var valid_574223 = path.getOrDefault("location")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "location", valid_574223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574224 = query.getOrDefault("api-version")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "api-version", valid_574224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574225: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_574218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  let valid = call_574225.validator(path, query, header, formData, body)
  let scheme = call_574225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574225.url(scheme.get, call_574225.host, call_574225.base,
                         call_574225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574225, url, valid)

proc call*(call_574226: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_574218;
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
  var path_574227 = newJObject()
  var query_574228 = newJObject()
  add(path_574227, "topicTypeName", newJString(topicTypeName))
  add(query_574228, "api-version", newJString(apiVersion))
  add(path_574227, "subscriptionId", newJString(subscriptionId))
  add(path_574227, "location", newJString(location))
  result = call_574226.call(path_574227, query_574228, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscriptionForTopicType* = Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_574218(
    name: "eventSubscriptionsListRegionalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_574219,
    base: "", url: url_EventSubscriptionsListRegionalBySubscriptionForTopicType_574220,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_574229 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListGlobalBySubscriptionForTopicType_574231(
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

proc validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_574230(
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
  var valid_574232 = path.getOrDefault("topicTypeName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "topicTypeName", valid_574232
  var valid_574233 = path.getOrDefault("subscriptionId")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "subscriptionId", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574235: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_574229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_574229;
          topicTypeName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalBySubscriptionForTopicType
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  add(path_574237, "topicTypeName", newJString(topicTypeName))
  add(query_574238, "api-version", newJString(apiVersion))
  add(path_574237, "subscriptionId", newJString(subscriptionId))
  result = call_574236.call(path_574237, query_574238, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscriptionForTopicType* = Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_574229(
    name: "eventSubscriptionsListGlobalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_574230,
    base: "", url: url_EventSubscriptionsListGlobalBySubscriptionForTopicType_574231,
    schemes: {Scheme.Https})
type
  Call_TopicsListBySubscription_574239 = ref object of OpenApiRestCall_573642
proc url_TopicsListBySubscription_574241(protocol: Scheme; host: string;
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

proc validate_TopicsListBySubscription_574240(path: JsonNode; query: JsonNode;
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
  var valid_574242 = path.getOrDefault("subscriptionId")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "subscriptionId", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574244: Call_TopicsListBySubscription_574239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under an Azure subscription
  ## 
  let valid = call_574244.validator(path, query, header, formData, body)
  let scheme = call_574244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574244.url(scheme.get, call_574244.host, call_574244.base,
                         call_574244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574244, url, valid)

proc call*(call_574245: Call_TopicsListBySubscription_574239; apiVersion: string;
          subscriptionId: string): Recallable =
  ## topicsListBySubscription
  ## List all the topics under an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574246 = newJObject()
  var query_574247 = newJObject()
  add(query_574247, "api-version", newJString(apiVersion))
  add(path_574246, "subscriptionId", newJString(subscriptionId))
  result = call_574245.call(path_574246, query_574247, nil, nil, nil)

var topicsListBySubscription* = Call_TopicsListBySubscription_574239(
    name: "topicsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListBySubscription_574240, base: "",
    url: url_TopicsListBySubscription_574241, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroup_574248 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListGlobalByResourceGroup_574250(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalByResourceGroup_574249(path: JsonNode;
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
  var valid_574251 = path.getOrDefault("resourceGroupName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "resourceGroupName", valid_574251
  var valid_574252 = path.getOrDefault("subscriptionId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "subscriptionId", valid_574252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574253 = query.getOrDefault("api-version")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "api-version", valid_574253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574254: Call_EventSubscriptionsListGlobalByResourceGroup_574248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ## 
  let valid = call_574254.validator(path, query, header, formData, body)
  let scheme = call_574254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574254.url(scheme.get, call_574254.host, call_574254.base,
                         call_574254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574254, url, valid)

proc call*(call_574255: Call_EventSubscriptionsListGlobalByResourceGroup_574248;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroup
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574256 = newJObject()
  var query_574257 = newJObject()
  add(path_574256, "resourceGroupName", newJString(resourceGroupName))
  add(query_574257, "api-version", newJString(apiVersion))
  add(path_574256, "subscriptionId", newJString(subscriptionId))
  result = call_574255.call(path_574256, query_574257, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroup* = Call_EventSubscriptionsListGlobalByResourceGroup_574248(
    name: "eventSubscriptionsListGlobalByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalByResourceGroup_574249,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroup_574250,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroup_574258 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListRegionalByResourceGroup_574260(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalByResourceGroup_574259(
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
  var valid_574261 = path.getOrDefault("resourceGroupName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "resourceGroupName", valid_574261
  var valid_574262 = path.getOrDefault("subscriptionId")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "subscriptionId", valid_574262
  var valid_574263 = path.getOrDefault("location")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "location", valid_574263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574265: Call_EventSubscriptionsListRegionalByResourceGroup_574258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_EventSubscriptionsListRegionalByResourceGroup_574258;
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
  var path_574267 = newJObject()
  var query_574268 = newJObject()
  add(path_574267, "resourceGroupName", newJString(resourceGroupName))
  add(query_574268, "api-version", newJString(apiVersion))
  add(path_574267, "subscriptionId", newJString(subscriptionId))
  add(path_574267, "location", newJString(location))
  result = call_574266.call(path_574267, query_574268, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroup* = Call_EventSubscriptionsListRegionalByResourceGroup_574258(
    name: "eventSubscriptionsListRegionalByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalByResourceGroup_574259,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroup_574260,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_574269 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListRegionalByResourceGroupForTopicType_574271(
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

proc validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_574270(
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
  var valid_574272 = path.getOrDefault("topicTypeName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "topicTypeName", valid_574272
  var valid_574273 = path.getOrDefault("resourceGroupName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "resourceGroupName", valid_574273
  var valid_574274 = path.getOrDefault("subscriptionId")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "subscriptionId", valid_574274
  var valid_574275 = path.getOrDefault("location")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "location", valid_574275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574276 = query.getOrDefault("api-version")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "api-version", valid_574276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574277: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_574269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ## 
  let valid = call_574277.validator(path, query, header, formData, body)
  let scheme = call_574277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574277.url(scheme.get, call_574277.host, call_574277.base,
                         call_574277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574277, url, valid)

proc call*(call_574278: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_574269;
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
  var path_574279 = newJObject()
  var query_574280 = newJObject()
  add(path_574279, "topicTypeName", newJString(topicTypeName))
  add(path_574279, "resourceGroupName", newJString(resourceGroupName))
  add(query_574280, "api-version", newJString(apiVersion))
  add(path_574279, "subscriptionId", newJString(subscriptionId))
  add(path_574279, "location", newJString(location))
  result = call_574278.call(path_574279, query_574280, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroupForTopicType* = Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_574269(
    name: "eventSubscriptionsListRegionalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_574270,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroupForTopicType_574271,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_574281 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListGlobalByResourceGroupForTopicType_574283(
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

proc validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_574282(
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
  var valid_574284 = path.getOrDefault("topicTypeName")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "topicTypeName", valid_574284
  var valid_574285 = path.getOrDefault("resourceGroupName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceGroupName", valid_574285
  var valid_574286 = path.getOrDefault("subscriptionId")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "subscriptionId", valid_574286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574287 = query.getOrDefault("api-version")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "api-version", valid_574287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574288: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_574281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  let valid = call_574288.validator(path, query, header, formData, body)
  let scheme = call_574288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574288.url(scheme.get, call_574288.host, call_574288.base,
                         call_574288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574288, url, valid)

proc call*(call_574289: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_574281;
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
  var path_574290 = newJObject()
  var query_574291 = newJObject()
  add(path_574290, "topicTypeName", newJString(topicTypeName))
  add(path_574290, "resourceGroupName", newJString(resourceGroupName))
  add(query_574291, "api-version", newJString(apiVersion))
  add(path_574290, "subscriptionId", newJString(subscriptionId))
  result = call_574289.call(path_574290, query_574291, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroupForTopicType* = Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_574281(
    name: "eventSubscriptionsListGlobalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_574282,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroupForTopicType_574283,
    schemes: {Scheme.Https})
type
  Call_TopicsListByResourceGroup_574292 = ref object of OpenApiRestCall_573642
proc url_TopicsListByResourceGroup_574294(protocol: Scheme; host: string;
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

proc validate_TopicsListByResourceGroup_574293(path: JsonNode; query: JsonNode;
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
  var valid_574295 = path.getOrDefault("resourceGroupName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "resourceGroupName", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574298: Call_TopicsListByResourceGroup_574292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under a resource group
  ## 
  let valid = call_574298.validator(path, query, header, formData, body)
  let scheme = call_574298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574298.url(scheme.get, call_574298.host, call_574298.base,
                         call_574298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574298, url, valid)

proc call*(call_574299: Call_TopicsListByResourceGroup_574292;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## topicsListByResourceGroup
  ## List all the topics under a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574300 = newJObject()
  var query_574301 = newJObject()
  add(path_574300, "resourceGroupName", newJString(resourceGroupName))
  add(query_574301, "api-version", newJString(apiVersion))
  add(path_574300, "subscriptionId", newJString(subscriptionId))
  result = call_574299.call(path_574300, query_574301, nil, nil, nil)

var topicsListByResourceGroup* = Call_TopicsListByResourceGroup_574292(
    name: "topicsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListByResourceGroup_574293, base: "",
    url: url_TopicsListByResourceGroup_574294, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_574313 = ref object of OpenApiRestCall_573642
proc url_TopicsCreateOrUpdate_574315(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsCreateOrUpdate_574314(path: JsonNode; query: JsonNode;
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
  var valid_574316 = path.getOrDefault("resourceGroupName")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "resourceGroupName", valid_574316
  var valid_574317 = path.getOrDefault("topicName")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "topicName", valid_574317
  var valid_574318 = path.getOrDefault("subscriptionId")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "subscriptionId", valid_574318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574319 = query.getOrDefault("api-version")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "api-version", valid_574319
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

proc call*(call_574321: Call_TopicsCreateOrUpdate_574313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  let valid = call_574321.validator(path, query, header, formData, body)
  let scheme = call_574321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574321.url(scheme.get, call_574321.host, call_574321.base,
                         call_574321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574321, url, valid)

proc call*(call_574322: Call_TopicsCreateOrUpdate_574313;
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
  var path_574323 = newJObject()
  var query_574324 = newJObject()
  var body_574325 = newJObject()
  add(path_574323, "resourceGroupName", newJString(resourceGroupName))
  add(query_574324, "api-version", newJString(apiVersion))
  add(path_574323, "topicName", newJString(topicName))
  add(path_574323, "subscriptionId", newJString(subscriptionId))
  if topicInfo != nil:
    body_574325 = topicInfo
  result = call_574322.call(path_574323, query_574324, nil, nil, body_574325)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_574313(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_574314, base: "",
    url: url_TopicsCreateOrUpdate_574315, schemes: {Scheme.Https})
type
  Call_TopicsGet_574302 = ref object of OpenApiRestCall_573642
proc url_TopicsGet_574304(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TopicsGet_574303(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574305 = path.getOrDefault("resourceGroupName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "resourceGroupName", valid_574305
  var valid_574306 = path.getOrDefault("topicName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "topicName", valid_574306
  var valid_574307 = path.getOrDefault("subscriptionId")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "subscriptionId", valid_574307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574308 = query.getOrDefault("api-version")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "api-version", valid_574308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574309: Call_TopicsGet_574302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a topic
  ## 
  let valid = call_574309.validator(path, query, header, formData, body)
  let scheme = call_574309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574309.url(scheme.get, call_574309.host, call_574309.base,
                         call_574309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574309, url, valid)

proc call*(call_574310: Call_TopicsGet_574302; resourceGroupName: string;
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
  var path_574311 = newJObject()
  var query_574312 = newJObject()
  add(path_574311, "resourceGroupName", newJString(resourceGroupName))
  add(query_574312, "api-version", newJString(apiVersion))
  add(path_574311, "topicName", newJString(topicName))
  add(path_574311, "subscriptionId", newJString(subscriptionId))
  result = call_574310.call(path_574311, query_574312, nil, nil, nil)

var topicsGet* = Call_TopicsGet_574302(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
                                    validator: validate_TopicsGet_574303,
                                    base: "", url: url_TopicsGet_574304,
                                    schemes: {Scheme.Https})
type
  Call_TopicsUpdate_574337 = ref object of OpenApiRestCall_573642
proc url_TopicsUpdate_574339(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsUpdate_574338(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously updates a topic with the specified parameters.
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
  var valid_574340 = path.getOrDefault("resourceGroupName")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "resourceGroupName", valid_574340
  var valid_574341 = path.getOrDefault("topicName")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "topicName", valid_574341
  var valid_574342 = path.getOrDefault("subscriptionId")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "subscriptionId", valid_574342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574343 = query.getOrDefault("api-version")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "api-version", valid_574343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   topicUpdateParameters: JObject (required)
  ##                        : Topic update information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574345: Call_TopicsUpdate_574337; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a topic with the specified parameters.
  ## 
  let valid = call_574345.validator(path, query, header, formData, body)
  let scheme = call_574345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574345.url(scheme.get, call_574345.host, call_574345.base,
                         call_574345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574345, url, valid)

proc call*(call_574346: Call_TopicsUpdate_574337; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string;
          topicUpdateParameters: JsonNode): Recallable =
  ## topicsUpdate
  ## Asynchronously updates a topic with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   topicUpdateParameters: JObject (required)
  ##                        : Topic update information
  var path_574347 = newJObject()
  var query_574348 = newJObject()
  var body_574349 = newJObject()
  add(path_574347, "resourceGroupName", newJString(resourceGroupName))
  add(query_574348, "api-version", newJString(apiVersion))
  add(path_574347, "topicName", newJString(topicName))
  add(path_574347, "subscriptionId", newJString(subscriptionId))
  if topicUpdateParameters != nil:
    body_574349 = topicUpdateParameters
  result = call_574346.call(path_574347, query_574348, nil, nil, body_574349)

var topicsUpdate* = Call_TopicsUpdate_574337(name: "topicsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsUpdate_574338, base: "", url: url_TopicsUpdate_574339,
    schemes: {Scheme.Https})
type
  Call_TopicsDelete_574326 = ref object of OpenApiRestCall_573642
proc url_TopicsDelete_574328(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsDelete_574327(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574329 = path.getOrDefault("resourceGroupName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "resourceGroupName", valid_574329
  var valid_574330 = path.getOrDefault("topicName")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "topicName", valid_574330
  var valid_574331 = path.getOrDefault("subscriptionId")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "subscriptionId", valid_574331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574332 = query.getOrDefault("api-version")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "api-version", valid_574332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574333: Call_TopicsDelete_574326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing topic
  ## 
  let valid = call_574333.validator(path, query, header, formData, body)
  let scheme = call_574333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574333.url(scheme.get, call_574333.host, call_574333.base,
                         call_574333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574333, url, valid)

proc call*(call_574334: Call_TopicsDelete_574326; resourceGroupName: string;
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
  var path_574335 = newJObject()
  var query_574336 = newJObject()
  add(path_574335, "resourceGroupName", newJString(resourceGroupName))
  add(query_574336, "api-version", newJString(apiVersion))
  add(path_574335, "topicName", newJString(topicName))
  add(path_574335, "subscriptionId", newJString(subscriptionId))
  result = call_574334.call(path_574335, query_574336, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_574326(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsDelete_574327, base: "", url: url_TopicsDelete_574328,
    schemes: {Scheme.Https})
type
  Call_TopicsListSharedAccessKeys_574350 = ref object of OpenApiRestCall_573642
proc url_TopicsListSharedAccessKeys_574352(protocol: Scheme; host: string;
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

proc validate_TopicsListSharedAccessKeys_574351(path: JsonNode; query: JsonNode;
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
  var valid_574353 = path.getOrDefault("resourceGroupName")
  valid_574353 = validateParameter(valid_574353, JString, required = true,
                                 default = nil)
  if valid_574353 != nil:
    section.add "resourceGroupName", valid_574353
  var valid_574354 = path.getOrDefault("topicName")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "topicName", valid_574354
  var valid_574355 = path.getOrDefault("subscriptionId")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "subscriptionId", valid_574355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574356 = query.getOrDefault("api-version")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "api-version", valid_574356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574357: Call_TopicsListSharedAccessKeys_574350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a topic
  ## 
  let valid = call_574357.validator(path, query, header, formData, body)
  let scheme = call_574357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574357.url(scheme.get, call_574357.host, call_574357.base,
                         call_574357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574357, url, valid)

proc call*(call_574358: Call_TopicsListSharedAccessKeys_574350;
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
  var path_574359 = newJObject()
  var query_574360 = newJObject()
  add(path_574359, "resourceGroupName", newJString(resourceGroupName))
  add(query_574360, "api-version", newJString(apiVersion))
  add(path_574359, "topicName", newJString(topicName))
  add(path_574359, "subscriptionId", newJString(subscriptionId))
  result = call_574358.call(path_574359, query_574360, nil, nil, nil)

var topicsListSharedAccessKeys* = Call_TopicsListSharedAccessKeys_574350(
    name: "topicsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/listKeys",
    validator: validate_TopicsListSharedAccessKeys_574351, base: "",
    url: url_TopicsListSharedAccessKeys_574352, schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKey_574361 = ref object of OpenApiRestCall_573642
proc url_TopicsRegenerateKey_574363(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsRegenerateKey_574362(path: JsonNode; query: JsonNode;
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
  var valid_574364 = path.getOrDefault("resourceGroupName")
  valid_574364 = validateParameter(valid_574364, JString, required = true,
                                 default = nil)
  if valid_574364 != nil:
    section.add "resourceGroupName", valid_574364
  var valid_574365 = path.getOrDefault("topicName")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "topicName", valid_574365
  var valid_574366 = path.getOrDefault("subscriptionId")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "subscriptionId", valid_574366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574367 = query.getOrDefault("api-version")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "api-version", valid_574367
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

proc call*(call_574369: Call_TopicsRegenerateKey_574361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a topic
  ## 
  let valid = call_574369.validator(path, query, header, formData, body)
  let scheme = call_574369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574369.url(scheme.get, call_574369.host, call_574369.base,
                         call_574369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574369, url, valid)

proc call*(call_574370: Call_TopicsRegenerateKey_574361; resourceGroupName: string;
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
  var path_574371 = newJObject()
  var query_574372 = newJObject()
  var body_574373 = newJObject()
  add(path_574371, "resourceGroupName", newJString(resourceGroupName))
  add(query_574372, "api-version", newJString(apiVersion))
  add(path_574371, "topicName", newJString(topicName))
  add(path_574371, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyRequest != nil:
    body_574373 = regenerateKeyRequest
  result = call_574370.call(path_574371, query_574372, nil, nil, body_574373)

var topicsRegenerateKey* = Call_TopicsRegenerateKey_574361(
    name: "topicsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/regenerateKey",
    validator: validate_TopicsRegenerateKey_574362, base: "",
    url: url_TopicsRegenerateKey_574363, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByResource_574374 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsListByResource_574376(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsListByResource_574375(path: JsonNode;
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
  var valid_574377 = path.getOrDefault("providerNamespace")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "providerNamespace", valid_574377
  var valid_574378 = path.getOrDefault("resourceGroupName")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "resourceGroupName", valid_574378
  var valid_574379 = path.getOrDefault("subscriptionId")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "subscriptionId", valid_574379
  var valid_574380 = path.getOrDefault("resourceName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "resourceName", valid_574380
  var valid_574381 = path.getOrDefault("resourceTypeName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "resourceTypeName", valid_574381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574382 = query.getOrDefault("api-version")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "api-version", valid_574382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574383: Call_EventSubscriptionsListByResource_574374;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific topic
  ## 
  let valid = call_574383.validator(path, query, header, formData, body)
  let scheme = call_574383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574383.url(scheme.get, call_574383.host, call_574383.base,
                         call_574383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574383, url, valid)

proc call*(call_574384: Call_EventSubscriptionsListByResource_574374;
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
  var path_574385 = newJObject()
  var query_574386 = newJObject()
  add(path_574385, "providerNamespace", newJString(providerNamespace))
  add(path_574385, "resourceGroupName", newJString(resourceGroupName))
  add(query_574386, "api-version", newJString(apiVersion))
  add(path_574385, "subscriptionId", newJString(subscriptionId))
  add(path_574385, "resourceName", newJString(resourceName))
  add(path_574385, "resourceTypeName", newJString(resourceTypeName))
  result = call_574384.call(path_574385, query_574386, nil, nil, nil)

var eventSubscriptionsListByResource* = Call_EventSubscriptionsListByResource_574374(
    name: "eventSubscriptionsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByResource_574375, base: "",
    url: url_EventSubscriptionsListByResource_574376, schemes: {Scheme.Https})
type
  Call_TopicsListEventTypes_574387 = ref object of OpenApiRestCall_573642
proc url_TopicsListEventTypes_574389(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListEventTypes_574388(path: JsonNode; query: JsonNode;
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
  var valid_574390 = path.getOrDefault("providerNamespace")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "providerNamespace", valid_574390
  var valid_574391 = path.getOrDefault("resourceGroupName")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "resourceGroupName", valid_574391
  var valid_574392 = path.getOrDefault("subscriptionId")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "subscriptionId", valid_574392
  var valid_574393 = path.getOrDefault("resourceName")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "resourceName", valid_574393
  var valid_574394 = path.getOrDefault("resourceTypeName")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "resourceTypeName", valid_574394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574395 = query.getOrDefault("api-version")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "api-version", valid_574395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574396: Call_TopicsListEventTypes_574387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic
  ## 
  let valid = call_574396.validator(path, query, header, formData, body)
  let scheme = call_574396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574396.url(scheme.get, call_574396.host, call_574396.base,
                         call_574396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574396, url, valid)

proc call*(call_574397: Call_TopicsListEventTypes_574387;
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
  var path_574398 = newJObject()
  var query_574399 = newJObject()
  add(path_574398, "providerNamespace", newJString(providerNamespace))
  add(path_574398, "resourceGroupName", newJString(resourceGroupName))
  add(query_574399, "api-version", newJString(apiVersion))
  add(path_574398, "subscriptionId", newJString(subscriptionId))
  add(path_574398, "resourceName", newJString(resourceName))
  add(path_574398, "resourceTypeName", newJString(resourceTypeName))
  result = call_574397.call(path_574398, query_574399, nil, nil, nil)

var topicsListEventTypes* = Call_TopicsListEventTypes_574387(
    name: "topicsListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventTypes",
    validator: validate_TopicsListEventTypes_574388, base: "",
    url: url_TopicsListEventTypes_574389, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsCreateOrUpdate_574410 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsCreateOrUpdate_574412(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "eventSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsCreateOrUpdate_574411(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription. Event subscription names must be between 3 and 64 characters in length and should use alphanumeric letters only.
  ##   scope: JString (required)
  ##        : The identifier of the resource to which the event subscription needs to be created or updated. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_574413 = path.getOrDefault("eventSubscriptionName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "eventSubscriptionName", valid_574413
  var valid_574414 = path.getOrDefault("scope")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "scope", valid_574414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574415 = query.getOrDefault("api-version")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "api-version", valid_574415
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

proc call*(call_574417: Call_EventSubscriptionsCreateOrUpdate_574410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ## 
  let valid = call_574417.validator(path, query, header, formData, body)
  let scheme = call_574417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574417.url(scheme.get, call_574417.host, call_574417.base,
                         call_574417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574417, url, valid)

proc call*(call_574418: Call_EventSubscriptionsCreateOrUpdate_574410;
          eventSubscriptionInfo: JsonNode; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsCreateOrUpdate
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ##   eventSubscriptionInfo: JObject (required)
  ##                        : Event subscription properties containing the destination and filter information
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription. Event subscription names must be between 3 and 64 characters in length and should use alphanumeric letters only.
  ##   scope: string (required)
  ##        : The identifier of the resource to which the event subscription needs to be created or updated. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_574419 = newJObject()
  var query_574420 = newJObject()
  var body_574421 = newJObject()
  if eventSubscriptionInfo != nil:
    body_574421 = eventSubscriptionInfo
  add(query_574420, "api-version", newJString(apiVersion))
  add(path_574419, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_574419, "scope", newJString(scope))
  result = call_574418.call(path_574419, query_574420, nil, nil, body_574421)

var eventSubscriptionsCreateOrUpdate* = Call_EventSubscriptionsCreateOrUpdate_574410(
    name: "eventSubscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsCreateOrUpdate_574411, base: "",
    url: url_EventSubscriptionsCreateOrUpdate_574412, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGet_574400 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsGet_574402(protocol: Scheme; host: string; base: string;
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

proc validate_EventSubscriptionsGet_574401(path: JsonNode; query: JsonNode;
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
  var valid_574403 = path.getOrDefault("eventSubscriptionName")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "eventSubscriptionName", valid_574403
  var valid_574404 = path.getOrDefault("scope")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = nil)
  if valid_574404 != nil:
    section.add "scope", valid_574404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574405 = query.getOrDefault("api-version")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "api-version", valid_574405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574406: Call_EventSubscriptionsGet_574400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of an event subscription
  ## 
  let valid = call_574406.validator(path, query, header, formData, body)
  let scheme = call_574406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574406.url(scheme.get, call_574406.host, call_574406.base,
                         call_574406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574406, url, valid)

proc call*(call_574407: Call_EventSubscriptionsGet_574400; apiVersion: string;
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
  var path_574408 = newJObject()
  var query_574409 = newJObject()
  add(query_574409, "api-version", newJString(apiVersion))
  add(path_574408, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_574408, "scope", newJString(scope))
  result = call_574407.call(path_574408, query_574409, nil, nil, nil)

var eventSubscriptionsGet* = Call_EventSubscriptionsGet_574400(
    name: "eventSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsGet_574401, base: "",
    url: url_EventSubscriptionsGet_574402, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsUpdate_574432 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsUpdate_574434(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsUpdate_574433(path: JsonNode; query: JsonNode;
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
  var valid_574435 = path.getOrDefault("eventSubscriptionName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "eventSubscriptionName", valid_574435
  var valid_574436 = path.getOrDefault("scope")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "scope", valid_574436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574437 = query.getOrDefault("api-version")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "api-version", valid_574437
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

proc call*(call_574439: Call_EventSubscriptionsUpdate_574432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates an existing event subscription.
  ## 
  let valid = call_574439.validator(path, query, header, formData, body)
  let scheme = call_574439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574439.url(scheme.get, call_574439.host, call_574439.base,
                         call_574439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574439, url, valid)

proc call*(call_574440: Call_EventSubscriptionsUpdate_574432; apiVersion: string;
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
  var path_574441 = newJObject()
  var query_574442 = newJObject()
  var body_574443 = newJObject()
  add(query_574442, "api-version", newJString(apiVersion))
  add(path_574441, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_574441, "scope", newJString(scope))
  if eventSubscriptionUpdateParameters != nil:
    body_574443 = eventSubscriptionUpdateParameters
  result = call_574440.call(path_574441, query_574442, nil, nil, body_574443)

var eventSubscriptionsUpdate* = Call_EventSubscriptionsUpdate_574432(
    name: "eventSubscriptionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsUpdate_574433, base: "",
    url: url_EventSubscriptionsUpdate_574434, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsDelete_574422 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsDelete_574424(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsDelete_574423(path: JsonNode; query: JsonNode;
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
  var valid_574425 = path.getOrDefault("eventSubscriptionName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "eventSubscriptionName", valid_574425
  var valid_574426 = path.getOrDefault("scope")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "scope", valid_574426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574427 = query.getOrDefault("api-version")
  valid_574427 = validateParameter(valid_574427, JString, required = true,
                                 default = nil)
  if valid_574427 != nil:
    section.add "api-version", valid_574427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574428: Call_EventSubscriptionsDelete_574422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing event subscription
  ## 
  let valid = call_574428.validator(path, query, header, formData, body)
  let scheme = call_574428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574428.url(scheme.get, call_574428.host, call_574428.base,
                         call_574428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574428, url, valid)

proc call*(call_574429: Call_EventSubscriptionsDelete_574422; apiVersion: string;
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
  var path_574430 = newJObject()
  var query_574431 = newJObject()
  add(query_574431, "api-version", newJString(apiVersion))
  add(path_574430, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_574430, "scope", newJString(scope))
  result = call_574429.call(path_574430, query_574431, nil, nil, nil)

var eventSubscriptionsDelete* = Call_EventSubscriptionsDelete_574422(
    name: "eventSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsDelete_574423, base: "",
    url: url_EventSubscriptionsDelete_574424, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGetFullUrl_574444 = ref object of OpenApiRestCall_573642
proc url_EventSubscriptionsGetFullUrl_574446(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsGetFullUrl_574445(path: JsonNode; query: JsonNode;
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
  var valid_574447 = path.getOrDefault("eventSubscriptionName")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "eventSubscriptionName", valid_574447
  var valid_574448 = path.getOrDefault("scope")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "scope", valid_574448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574449 = query.getOrDefault("api-version")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "api-version", valid_574449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574450: Call_EventSubscriptionsGetFullUrl_574444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the full endpoint URL for an event subscription
  ## 
  let valid = call_574450.validator(path, query, header, formData, body)
  let scheme = call_574450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574450.url(scheme.get, call_574450.host, call_574450.base,
                         call_574450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574450, url, valid)

proc call*(call_574451: Call_EventSubscriptionsGetFullUrl_574444;
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
  var path_574452 = newJObject()
  var query_574453 = newJObject()
  add(query_574453, "api-version", newJString(apiVersion))
  add(path_574452, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_574452, "scope", newJString(scope))
  result = call_574451.call(path_574452, query_574453, nil, nil, nil)

var eventSubscriptionsGetFullUrl* = Call_EventSubscriptionsGetFullUrl_574444(
    name: "eventSubscriptionsGetFullUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}/getFullUrl",
    validator: validate_EventSubscriptionsGetFullUrl_574445, base: "",
    url: url_EventSubscriptionsGetFullUrl_574446, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
