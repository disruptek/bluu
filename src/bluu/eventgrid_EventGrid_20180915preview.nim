
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventGridManagementClient
## version: 2018-09-15-preview
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

  OpenApiRestCall_567651 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567651](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567651): Option[Scheme] {.used.} =
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
  Call_OperationsList_567873 = ref object of OpenApiRestCall_567651
proc url_OperationsList_567875(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567874(path: JsonNode; query: JsonNode;
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
  var valid_568034 = query.getOrDefault("api-version")
  valid_568034 = validateParameter(valid_568034, JString, required = true,
                                 default = nil)
  if valid_568034 != nil:
    section.add "api-version", valid_568034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568057: Call_OperationsList_567873; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the available operations supported by the Microsoft.EventGrid resource provider
  ## 
  let valid = call_568057.validator(path, query, header, formData, body)
  let scheme = call_568057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568057.url(scheme.get, call_568057.host, call_568057.base,
                         call_568057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568057, url, valid)

proc call*(call_568128: Call_OperationsList_567873; apiVersion: string): Recallable =
  ## operationsList
  ## List the available operations supported by the Microsoft.EventGrid resource provider
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_568129 = newJObject()
  add(query_568129, "api-version", newJString(apiVersion))
  result = call_568128.call(nil, query_568129, nil, nil, nil)

var operationsList* = Call_OperationsList_567873(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/operations",
    validator: validate_OperationsList_567874, base: "", url: url_OperationsList_567875,
    schemes: {Scheme.Https})
type
  Call_TopicTypesList_568169 = ref object of OpenApiRestCall_567651
proc url_TopicTypesList_568171(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TopicTypesList_568170(path: JsonNode; query: JsonNode;
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
  var valid_568172 = query.getOrDefault("api-version")
  valid_568172 = validateParameter(valid_568172, JString, required = true,
                                 default = nil)
  if valid_568172 != nil:
    section.add "api-version", valid_568172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568173: Call_TopicTypesList_568169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all registered topic types
  ## 
  let valid = call_568173.validator(path, query, header, formData, body)
  let scheme = call_568173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568173.url(scheme.get, call_568173.host, call_568173.base,
                         call_568173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568173, url, valid)

proc call*(call_568174: Call_TopicTypesList_568169; apiVersion: string): Recallable =
  ## topicTypesList
  ## List all registered topic types
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_568175 = newJObject()
  add(query_568175, "api-version", newJString(apiVersion))
  result = call_568174.call(nil, query_568175, nil, nil, nil)

var topicTypesList* = Call_TopicTypesList_568169(name: "topicTypesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/topicTypes",
    validator: validate_TopicTypesList_568170, base: "", url: url_TopicTypesList_568171,
    schemes: {Scheme.Https})
type
  Call_TopicTypesGet_568176 = ref object of OpenApiRestCall_567651
proc url_TopicTypesGet_568178(protocol: Scheme; host: string; base: string;
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

proc validate_TopicTypesGet_568177(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_568195: Call_TopicTypesGet_568176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a topic type
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_TopicTypesGet_568176; topicTypeName: string;
          apiVersion: string): Recallable =
  ## topicTypesGet
  ## Get information about a topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(path_568197, "topicTypeName", newJString(topicTypeName))
  add(query_568198, "api-version", newJString(apiVersion))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var topicTypesGet* = Call_TopicTypesGet_568176(name: "topicTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}",
    validator: validate_TopicTypesGet_568177, base: "", url: url_TopicTypesGet_568178,
    schemes: {Scheme.Https})
type
  Call_TopicTypesListEventTypes_568199 = ref object of OpenApiRestCall_567651
proc url_TopicTypesListEventTypes_568201(protocol: Scheme; host: string;
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

proc validate_TopicTypesListEventTypes_568200(path: JsonNode; query: JsonNode;
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
  var valid_568202 = path.getOrDefault("topicTypeName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "topicTypeName", valid_568202
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

proc call*(call_568204: Call_TopicTypesListEventTypes_568199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic type
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_TopicTypesListEventTypes_568199;
          topicTypeName: string; apiVersion: string): Recallable =
  ## topicTypesListEventTypes
  ## List event types for a topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "topicTypeName", newJString(topicTypeName))
  add(query_568207, "api-version", newJString(apiVersion))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var topicTypesListEventTypes* = Call_TopicTypesListEventTypes_568199(
    name: "topicTypesListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventTypes",
    validator: validate_TopicTypesListEventTypes_568200, base: "",
    url: url_TopicTypesListEventTypes_568201, schemes: {Scheme.Https})
type
  Call_DomainsListBySubscription_568208 = ref object of OpenApiRestCall_567651
proc url_DomainsListBySubscription_568210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsListBySubscription_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the domains under an Azure subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_DomainsListBySubscription_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the domains under an Azure subscription
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_DomainsListBySubscription_568208; apiVersion: string;
          subscriptionId: string): Recallable =
  ## domainsListBySubscription
  ## List all the domains under an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var domainsListBySubscription* = Call_DomainsListBySubscription_568208(
    name: "domainsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/domains",
    validator: validate_DomainsListBySubscription_568209, base: "",
    url: url_DomainsListBySubscription_568210, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscription_568217 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalBySubscription_568219(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalBySubscription_568218(path: JsonNode;
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
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_EventSubscriptionsListGlobalBySubscription_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_EventSubscriptionsListGlobalBySubscription_568217;
          apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalBySubscription
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscription* = Call_EventSubscriptionsListGlobalBySubscription_568217(
    name: "eventSubscriptionsListGlobalBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscription_568218,
    base: "", url: url_EventSubscriptionsListGlobalBySubscription_568219,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscription_568226 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalBySubscription_568228(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalBySubscription_568227(path: JsonNode;
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
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("location")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "location", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_EventSubscriptionsListRegionalBySubscription_568226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_EventSubscriptionsListRegionalBySubscription_568226;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## eventSubscriptionsListRegionalBySubscription
  ## List all event subscriptions from the given location under a specific Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the location
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(path_568234, "location", newJString(location))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscription* = Call_EventSubscriptionsListRegionalBySubscription_568226(
    name: "eventSubscriptionsListRegionalBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalBySubscription_568227,
    base: "", url: url_EventSubscriptionsListRegionalBySubscription_568228,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568236 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568238(
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

proc validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568237(
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
  var valid_568239 = path.getOrDefault("topicTypeName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "topicTypeName", valid_568239
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  var valid_568241 = path.getOrDefault("location")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "location", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568236;
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
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "topicTypeName", newJString(topicTypeName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(path_568245, "location", newJString(location))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscriptionForTopicType* = Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568236(
    name: "eventSubscriptionsListRegionalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568237,
    base: "", url: url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568238,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568247 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568249(
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

proc validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568248(
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
  var valid_568250 = path.getOrDefault("topicTypeName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "topicTypeName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568247;
          topicTypeName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalBySubscriptionForTopicType
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(path_568255, "topicTypeName", newJString(topicTypeName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscriptionForTopicType* = Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568247(
    name: "eventSubscriptionsListGlobalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568248,
    base: "", url: url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568249,
    schemes: {Scheme.Https})
type
  Call_TopicsListBySubscription_568257 = ref object of OpenApiRestCall_567651
proc url_TopicsListBySubscription_568259(protocol: Scheme; host: string;
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

proc validate_TopicsListBySubscription_568258(path: JsonNode; query: JsonNode;
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
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_TopicsListBySubscription_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under an Azure subscription
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_TopicsListBySubscription_568257; apiVersion: string;
          subscriptionId: string): Recallable =
  ## topicsListBySubscription
  ## List all the topics under an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var topicsListBySubscription* = Call_TopicsListBySubscription_568257(
    name: "topicsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListBySubscription_568258, base: "",
    url: url_TopicsListBySubscription_568259, schemes: {Scheme.Https})
type
  Call_DomainsListByResourceGroup_568266 = ref object of OpenApiRestCall_567651
proc url_DomainsListByResourceGroup_568268(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsListByResourceGroup_568267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the domains under a resource group
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
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_DomainsListByResourceGroup_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the domains under a resource group
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_DomainsListByResourceGroup_568266;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## domainsListByResourceGroup
  ## List all the domains under a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var domainsListByResourceGroup* = Call_DomainsListByResourceGroup_568266(
    name: "domainsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains",
    validator: validate_DomainsListByResourceGroup_568267, base: "",
    url: url_DomainsListByResourceGroup_568268, schemes: {Scheme.Https})
type
  Call_DomainsCreateOrUpdate_568287 = ref object of OpenApiRestCall_567651
proc url_DomainsCreateOrUpdate_568289(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsCreateOrUpdate_568288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new domain with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("domainName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "domainName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   domainInfo: JObject (required)
  ##             : Domain information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_DomainsCreateOrUpdate_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new domain with the specified parameters.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_DomainsCreateOrUpdate_568287;
          resourceGroupName: string; domainInfo: JsonNode; apiVersion: string;
          subscriptionId: string; domainName: string): Recallable =
  ## domainsCreateOrUpdate
  ## Asynchronously creates a new domain with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   domainInfo: JObject (required)
  ##             : Domain information
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  var body_568299 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  if domainInfo != nil:
    body_568299 = domainInfo
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(path_568297, "domainName", newJString(domainName))
  result = call_568296.call(path_568297, query_568298, nil, nil, body_568299)

var domainsCreateOrUpdate* = Call_DomainsCreateOrUpdate_568287(
    name: "domainsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsCreateOrUpdate_568288, base: "",
    url: url_DomainsCreateOrUpdate_568289, schemes: {Scheme.Https})
type
  Call_DomainsGet_568276 = ref object of OpenApiRestCall_567651
proc url_DomainsGet_568278(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsGet_568277(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a domain
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("domainName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "domainName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_DomainsGet_568276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a domain
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_DomainsGet_568276; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainName: string): Recallable =
  ## domainsGet
  ## Get properties of a domain
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  add(path_568285, "domainName", newJString(domainName))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var domainsGet* = Call_DomainsGet_568276(name: "domainsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
                                      validator: validate_DomainsGet_568277,
                                      base: "", url: url_DomainsGet_568278,
                                      schemes: {Scheme.Https})
type
  Call_DomainsUpdate_568311 = ref object of OpenApiRestCall_567651
proc url_DomainsUpdate_568313(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsUpdate_568312(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously updates a domain with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568316 = path.getOrDefault("domainName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "domainName", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   domainUpdateParameters: JObject (required)
  ##                         : Domain update information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_DomainsUpdate_568311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a domain with the specified parameters.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_DomainsUpdate_568311; resourceGroupName: string;
          apiVersion: string; domainUpdateParameters: JsonNode;
          subscriptionId: string; domainName: string): Recallable =
  ## domainsUpdate
  ## Asynchronously updates a domain with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   domainUpdateParameters: JObject (required)
  ##                         : Domain update information
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  var body_568323 = newJObject()
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  if domainUpdateParameters != nil:
    body_568323 = domainUpdateParameters
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  add(path_568321, "domainName", newJString(domainName))
  result = call_568320.call(path_568321, query_568322, nil, nil, body_568323)

var domainsUpdate* = Call_DomainsUpdate_568311(name: "domainsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsUpdate_568312, base: "", url: url_DomainsUpdate_568313,
    schemes: {Scheme.Https})
type
  Call_DomainsDelete_568300 = ref object of OpenApiRestCall_567651
proc url_DomainsDelete_568302(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsDelete_568301(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete existing domain
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("domainName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "domainName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_DomainsDelete_568300; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing domain
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_DomainsDelete_568300; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainName: string): Recallable =
  ## domainsDelete
  ## Delete existing domain
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  add(path_568309, "domainName", newJString(domainName))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var domainsDelete* = Call_DomainsDelete_568300(name: "domainsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsDelete_568301, base: "", url: url_DomainsDelete_568302,
    schemes: {Scheme.Https})
type
  Call_DomainsListSharedAccessKeys_568324 = ref object of OpenApiRestCall_567651
proc url_DomainsListSharedAccessKeys_568326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsListSharedAccessKeys_568325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the two keys used to publish to a domain
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("domainName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "domainName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_DomainsListSharedAccessKeys_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a domain
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_DomainsListSharedAccessKeys_568324;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainName: string): Recallable =
  ## domainsListSharedAccessKeys
  ## List the two keys used to publish to a domain
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  add(path_568333, "domainName", newJString(domainName))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var domainsListSharedAccessKeys* = Call_DomainsListSharedAccessKeys_568324(
    name: "domainsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/listKeys",
    validator: validate_DomainsListSharedAccessKeys_568325, base: "",
    url: url_DomainsListSharedAccessKeys_568326, schemes: {Scheme.Https})
type
  Call_DomainsRegenerateKey_568335 = ref object of OpenApiRestCall_567651
proc url_DomainsRegenerateKey_568337(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainsRegenerateKey_568336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate a shared access key for a domain
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568338 = path.getOrDefault("resourceGroupName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceGroupName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  var valid_568340 = path.getOrDefault("domainName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "domainName", valid_568340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568341 = query.getOrDefault("api-version")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "api-version", valid_568341
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

proc call*(call_568343: Call_DomainsRegenerateKey_568335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a domain
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_DomainsRegenerateKey_568335;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainName: string; regenerateKeyRequest: JsonNode): Recallable =
  ## domainsRegenerateKey
  ## Regenerate a shared access key for a domain
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  var body_568347 = newJObject()
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  add(path_568345, "domainName", newJString(domainName))
  if regenerateKeyRequest != nil:
    body_568347 = regenerateKeyRequest
  result = call_568344.call(path_568345, query_568346, nil, nil, body_568347)

var domainsRegenerateKey* = Call_DomainsRegenerateKey_568335(
    name: "domainsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/regenerateKey",
    validator: validate_DomainsRegenerateKey_568336, base: "",
    url: url_DomainsRegenerateKey_568337, schemes: {Scheme.Https})
type
  Call_DomainTopicsListByDomain_568348 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsListByDomain_568350(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainTopicsListByDomain_568349(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the topics in a domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Domain name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568351 = path.getOrDefault("resourceGroupName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceGroupName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  var valid_568353 = path.getOrDefault("domainName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "domainName", valid_568353
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
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_DomainTopicsListByDomain_568348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics in a domain.
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_DomainTopicsListByDomain_568348;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainName: string): Recallable =
  ## domainTopicsListByDomain
  ## List all the topics in a domain.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Domain name.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  add(path_568357, "domainName", newJString(domainName))
  result = call_568356.call(path_568357, query_568358, nil, nil, nil)

var domainTopicsListByDomain* = Call_DomainTopicsListByDomain_568348(
    name: "domainTopicsListByDomain", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics",
    validator: validate_DomainTopicsListByDomain_568349, base: "",
    url: url_DomainTopicsListByDomain_568350, schemes: {Scheme.Https})
type
  Call_DomainTopicsGet_568359 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsGet_568361(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainTopicsGet_568360(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get properties of a domain topic
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
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568362 = path.getOrDefault("resourceGroupName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "resourceGroupName", valid_568362
  var valid_568363 = path.getOrDefault("topicName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "topicName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  var valid_568365 = path.getOrDefault("domainName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "domainName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_DomainTopicsGet_568359; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a domain topic
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_DomainTopicsGet_568359; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string;
          domainName: string): Recallable =
  ## domainTopicsGet
  ## Get properties of a domain topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "topicName", newJString(topicName))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  add(path_568369, "domainName", newJString(domainName))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var domainTopicsGet* = Call_DomainTopicsGet_568359(name: "domainTopicsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{topicName}",
    validator: validate_DomainTopicsGet_568360, base: "", url: url_DomainTopicsGet_568361,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByDomainTopic_568371 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListByDomainTopic_568373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListByDomainTopic_568372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all event subscriptions that have been created for a specific domain topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the domain topic
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the top level domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("topicName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "topicName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("domainName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "domainName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_EventSubscriptionsListByDomainTopic_568371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific domain topic
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_EventSubscriptionsListByDomainTopic_568371;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; domainName: string): Recallable =
  ## eventSubscriptionsListByDomainTopic
  ## List all event subscriptions that have been created for a specific domain topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the domain topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the top level domain
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "topicName", newJString(topicName))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "domainName", newJString(domainName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var eventSubscriptionsListByDomainTopic* = Call_EventSubscriptionsListByDomainTopic_568371(
    name: "eventSubscriptionsListByDomainTopic", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{topicName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByDomainTopic_568372, base: "",
    url: url_EventSubscriptionsListByDomainTopic_568373, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroup_568383 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalByResourceGroup_568385(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalByResourceGroup_568384(path: JsonNode;
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
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_EventSubscriptionsListGlobalByResourceGroup_568383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_EventSubscriptionsListGlobalByResourceGroup_568383;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroup
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroup* = Call_EventSubscriptionsListGlobalByResourceGroup_568383(
    name: "eventSubscriptionsListGlobalByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalByResourceGroup_568384,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroup_568385,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroup_568393 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalByResourceGroup_568395(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalByResourceGroup_568394(
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
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  var valid_568398 = path.getOrDefault("location")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "location", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_EventSubscriptionsListRegionalByResourceGroup_568393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_EventSubscriptionsListRegionalByResourceGroup_568393;
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
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  add(path_568402, "location", newJString(location))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroup* = Call_EventSubscriptionsListRegionalByResourceGroup_568393(
    name: "eventSubscriptionsListRegionalByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalByResourceGroup_568394,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroup_568395,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568404 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568406(
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

proc validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568405(
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
  var valid_568407 = path.getOrDefault("topicTypeName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "topicTypeName", valid_568407
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("location")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "location", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568404;
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
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "topicTypeName", newJString(topicTypeName))
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "location", newJString(location))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroupForTopicType* = Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568404(
    name: "eventSubscriptionsListRegionalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568405,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568406,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568416 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568418(
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

proc validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568417(
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
  var valid_568419 = path.getOrDefault("topicTypeName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "topicTypeName", valid_568419
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568416;
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
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "topicTypeName", newJString(topicTypeName))
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroupForTopicType* = Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568416(
    name: "eventSubscriptionsListGlobalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568417,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568418,
    schemes: {Scheme.Https})
type
  Call_TopicsListByResourceGroup_568427 = ref object of OpenApiRestCall_567651
proc url_TopicsListByResourceGroup_568429(protocol: Scheme; host: string;
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

proc validate_TopicsListByResourceGroup_568428(path: JsonNode; query: JsonNode;
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
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568433: Call_TopicsListByResourceGroup_568427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under a resource group
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_TopicsListByResourceGroup_568427;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## topicsListByResourceGroup
  ## List all the topics under a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  add(path_568435, "resourceGroupName", newJString(resourceGroupName))
  add(query_568436, "api-version", newJString(apiVersion))
  add(path_568435, "subscriptionId", newJString(subscriptionId))
  result = call_568434.call(path_568435, query_568436, nil, nil, nil)

var topicsListByResourceGroup* = Call_TopicsListByResourceGroup_568427(
    name: "topicsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListByResourceGroup_568428, base: "",
    url: url_TopicsListByResourceGroup_568429, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568448 = ref object of OpenApiRestCall_567651
proc url_TopicsCreateOrUpdate_568450(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsCreateOrUpdate_568449(path: JsonNode; query: JsonNode;
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
  var valid_568451 = path.getOrDefault("resourceGroupName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "resourceGroupName", valid_568451
  var valid_568452 = path.getOrDefault("topicName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "topicName", valid_568452
  var valid_568453 = path.getOrDefault("subscriptionId")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "subscriptionId", valid_568453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "api-version", valid_568454
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

proc call*(call_568456: Call_TopicsCreateOrUpdate_568448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_TopicsCreateOrUpdate_568448;
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
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  var body_568460 = newJObject()
  add(path_568458, "resourceGroupName", newJString(resourceGroupName))
  add(query_568459, "api-version", newJString(apiVersion))
  add(path_568458, "topicName", newJString(topicName))
  add(path_568458, "subscriptionId", newJString(subscriptionId))
  if topicInfo != nil:
    body_568460 = topicInfo
  result = call_568457.call(path_568458, query_568459, nil, nil, body_568460)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568448(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568449, base: "",
    url: url_TopicsCreateOrUpdate_568450, schemes: {Scheme.Https})
type
  Call_TopicsGet_568437 = ref object of OpenApiRestCall_567651
proc url_TopicsGet_568439(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TopicsGet_568438(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("topicName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "topicName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_TopicsGet_568437; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a topic
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_TopicsGet_568437; resourceGroupName: string;
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
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "topicName", newJString(topicName))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  result = call_568445.call(path_568446, query_568447, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568437(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
                                    validator: validate_TopicsGet_568438,
                                    base: "", url: url_TopicsGet_568439,
                                    schemes: {Scheme.Https})
type
  Call_TopicsUpdate_568472 = ref object of OpenApiRestCall_567651
proc url_TopicsUpdate_568474(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsUpdate_568473(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568475 = path.getOrDefault("resourceGroupName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "resourceGroupName", valid_568475
  var valid_568476 = path.getOrDefault("topicName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "topicName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
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

proc call*(call_568480: Call_TopicsUpdate_568472; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a topic with the specified parameters.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_TopicsUpdate_568472; resourceGroupName: string;
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
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  var body_568484 = newJObject()
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "topicName", newJString(topicName))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  if topicUpdateParameters != nil:
    body_568484 = topicUpdateParameters
  result = call_568481.call(path_568482, query_568483, nil, nil, body_568484)

var topicsUpdate* = Call_TopicsUpdate_568472(name: "topicsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsUpdate_568473, base: "", url: url_TopicsUpdate_568474,
    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568461 = ref object of OpenApiRestCall_567651
proc url_TopicsDelete_568463(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsDelete_568462(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568464 = path.getOrDefault("resourceGroupName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "resourceGroupName", valid_568464
  var valid_568465 = path.getOrDefault("topicName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "topicName", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "api-version", valid_568467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568468: Call_TopicsDelete_568461; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing topic
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_TopicsDelete_568461; resourceGroupName: string;
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
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  add(path_568470, "resourceGroupName", newJString(resourceGroupName))
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "topicName", newJString(topicName))
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  result = call_568469.call(path_568470, query_568471, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568461(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsDelete_568462, base: "", url: url_TopicsDelete_568463,
    schemes: {Scheme.Https})
type
  Call_TopicsListSharedAccessKeys_568485 = ref object of OpenApiRestCall_567651
proc url_TopicsListSharedAccessKeys_568487(protocol: Scheme; host: string;
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

proc validate_TopicsListSharedAccessKeys_568486(path: JsonNode; query: JsonNode;
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
  var valid_568488 = path.getOrDefault("resourceGroupName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "resourceGroupName", valid_568488
  var valid_568489 = path.getOrDefault("topicName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "topicName", valid_568489
  var valid_568490 = path.getOrDefault("subscriptionId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "subscriptionId", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568492: Call_TopicsListSharedAccessKeys_568485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a topic
  ## 
  let valid = call_568492.validator(path, query, header, formData, body)
  let scheme = call_568492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568492.url(scheme.get, call_568492.host, call_568492.base,
                         call_568492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568492, url, valid)

proc call*(call_568493: Call_TopicsListSharedAccessKeys_568485;
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
  var path_568494 = newJObject()
  var query_568495 = newJObject()
  add(path_568494, "resourceGroupName", newJString(resourceGroupName))
  add(query_568495, "api-version", newJString(apiVersion))
  add(path_568494, "topicName", newJString(topicName))
  add(path_568494, "subscriptionId", newJString(subscriptionId))
  result = call_568493.call(path_568494, query_568495, nil, nil, nil)

var topicsListSharedAccessKeys* = Call_TopicsListSharedAccessKeys_568485(
    name: "topicsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/listKeys",
    validator: validate_TopicsListSharedAccessKeys_568486, base: "",
    url: url_TopicsListSharedAccessKeys_568487, schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKey_568496 = ref object of OpenApiRestCall_567651
proc url_TopicsRegenerateKey_568498(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsRegenerateKey_568497(path: JsonNode; query: JsonNode;
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
  var valid_568499 = path.getOrDefault("resourceGroupName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "resourceGroupName", valid_568499
  var valid_568500 = path.getOrDefault("topicName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "topicName", valid_568500
  var valid_568501 = path.getOrDefault("subscriptionId")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "subscriptionId", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568502 = query.getOrDefault("api-version")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "api-version", valid_568502
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

proc call*(call_568504: Call_TopicsRegenerateKey_568496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a topic
  ## 
  let valid = call_568504.validator(path, query, header, formData, body)
  let scheme = call_568504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568504.url(scheme.get, call_568504.host, call_568504.base,
                         call_568504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568504, url, valid)

proc call*(call_568505: Call_TopicsRegenerateKey_568496; resourceGroupName: string;
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
  var path_568506 = newJObject()
  var query_568507 = newJObject()
  var body_568508 = newJObject()
  add(path_568506, "resourceGroupName", newJString(resourceGroupName))
  add(query_568507, "api-version", newJString(apiVersion))
  add(path_568506, "topicName", newJString(topicName))
  add(path_568506, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyRequest != nil:
    body_568508 = regenerateKeyRequest
  result = call_568505.call(path_568506, query_568507, nil, nil, body_568508)

var topicsRegenerateKey* = Call_TopicsRegenerateKey_568496(
    name: "topicsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/regenerateKey",
    validator: validate_TopicsRegenerateKey_568497, base: "",
    url: url_TopicsRegenerateKey_568498, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByResource_568509 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListByResource_568511(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsListByResource_568510(path: JsonNode;
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
  var valid_568512 = path.getOrDefault("providerNamespace")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "providerNamespace", valid_568512
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("subscriptionId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "subscriptionId", valid_568514
  var valid_568515 = path.getOrDefault("resourceName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceName", valid_568515
  var valid_568516 = path.getOrDefault("resourceTypeName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "resourceTypeName", valid_568516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568517 = query.getOrDefault("api-version")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "api-version", valid_568517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568518: Call_EventSubscriptionsListByResource_568509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific topic
  ## 
  let valid = call_568518.validator(path, query, header, formData, body)
  let scheme = call_568518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568518.url(scheme.get, call_568518.host, call_568518.base,
                         call_568518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568518, url, valid)

proc call*(call_568519: Call_EventSubscriptionsListByResource_568509;
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
  var path_568520 = newJObject()
  var query_568521 = newJObject()
  add(path_568520, "providerNamespace", newJString(providerNamespace))
  add(path_568520, "resourceGroupName", newJString(resourceGroupName))
  add(query_568521, "api-version", newJString(apiVersion))
  add(path_568520, "subscriptionId", newJString(subscriptionId))
  add(path_568520, "resourceName", newJString(resourceName))
  add(path_568520, "resourceTypeName", newJString(resourceTypeName))
  result = call_568519.call(path_568520, query_568521, nil, nil, nil)

var eventSubscriptionsListByResource* = Call_EventSubscriptionsListByResource_568509(
    name: "eventSubscriptionsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByResource_568510, base: "",
    url: url_EventSubscriptionsListByResource_568511, schemes: {Scheme.Https})
type
  Call_TopicsListEventTypes_568522 = ref object of OpenApiRestCall_567651
proc url_TopicsListEventTypes_568524(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListEventTypes_568523(path: JsonNode; query: JsonNode;
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
  var valid_568525 = path.getOrDefault("providerNamespace")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "providerNamespace", valid_568525
  var valid_568526 = path.getOrDefault("resourceGroupName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "resourceGroupName", valid_568526
  var valid_568527 = path.getOrDefault("subscriptionId")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "subscriptionId", valid_568527
  var valid_568528 = path.getOrDefault("resourceName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceName", valid_568528
  var valid_568529 = path.getOrDefault("resourceTypeName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "resourceTypeName", valid_568529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568530 = query.getOrDefault("api-version")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "api-version", valid_568530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568531: Call_TopicsListEventTypes_568522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic
  ## 
  let valid = call_568531.validator(path, query, header, formData, body)
  let scheme = call_568531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568531.url(scheme.get, call_568531.host, call_568531.base,
                         call_568531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568531, url, valid)

proc call*(call_568532: Call_TopicsListEventTypes_568522;
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
  var path_568533 = newJObject()
  var query_568534 = newJObject()
  add(path_568533, "providerNamespace", newJString(providerNamespace))
  add(path_568533, "resourceGroupName", newJString(resourceGroupName))
  add(query_568534, "api-version", newJString(apiVersion))
  add(path_568533, "subscriptionId", newJString(subscriptionId))
  add(path_568533, "resourceName", newJString(resourceName))
  add(path_568533, "resourceTypeName", newJString(resourceTypeName))
  result = call_568532.call(path_568533, query_568534, nil, nil, nil)

var topicsListEventTypes* = Call_TopicsListEventTypes_568522(
    name: "topicsListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventTypes",
    validator: validate_TopicsListEventTypes_568523, base: "",
    url: url_TopicsListEventTypes_568524, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsCreateOrUpdate_568545 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsCreateOrUpdate_568547(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsCreateOrUpdate_568546(path: JsonNode;
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
  var valid_568548 = path.getOrDefault("eventSubscriptionName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "eventSubscriptionName", valid_568548
  var valid_568549 = path.getOrDefault("scope")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "scope", valid_568549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568550 = query.getOrDefault("api-version")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "api-version", valid_568550
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

proc call*(call_568552: Call_EventSubscriptionsCreateOrUpdate_568545;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ## 
  let valid = call_568552.validator(path, query, header, formData, body)
  let scheme = call_568552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568552.url(scheme.get, call_568552.host, call_568552.base,
                         call_568552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568552, url, valid)

proc call*(call_568553: Call_EventSubscriptionsCreateOrUpdate_568545;
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
  var path_568554 = newJObject()
  var query_568555 = newJObject()
  var body_568556 = newJObject()
  if eventSubscriptionInfo != nil:
    body_568556 = eventSubscriptionInfo
  add(query_568555, "api-version", newJString(apiVersion))
  add(path_568554, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568554, "scope", newJString(scope))
  result = call_568553.call(path_568554, query_568555, nil, nil, body_568556)

var eventSubscriptionsCreateOrUpdate* = Call_EventSubscriptionsCreateOrUpdate_568545(
    name: "eventSubscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsCreateOrUpdate_568546, base: "",
    url: url_EventSubscriptionsCreateOrUpdate_568547, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGet_568535 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsGet_568537(protocol: Scheme; host: string; base: string;
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

proc validate_EventSubscriptionsGet_568536(path: JsonNode; query: JsonNode;
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
  var valid_568538 = path.getOrDefault("eventSubscriptionName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "eventSubscriptionName", valid_568538
  var valid_568539 = path.getOrDefault("scope")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "scope", valid_568539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568540 = query.getOrDefault("api-version")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "api-version", valid_568540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568541: Call_EventSubscriptionsGet_568535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of an event subscription
  ## 
  let valid = call_568541.validator(path, query, header, formData, body)
  let scheme = call_568541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568541.url(scheme.get, call_568541.host, call_568541.base,
                         call_568541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568541, url, valid)

proc call*(call_568542: Call_EventSubscriptionsGet_568535; apiVersion: string;
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
  var path_568543 = newJObject()
  var query_568544 = newJObject()
  add(query_568544, "api-version", newJString(apiVersion))
  add(path_568543, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568543, "scope", newJString(scope))
  result = call_568542.call(path_568543, query_568544, nil, nil, nil)

var eventSubscriptionsGet* = Call_EventSubscriptionsGet_568535(
    name: "eventSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsGet_568536, base: "",
    url: url_EventSubscriptionsGet_568537, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsUpdate_568567 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsUpdate_568569(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsUpdate_568568(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously updates an existing event subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription to be updated
  ##   scope: JString (required)
  ##        : The scope of existing event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568570 = path.getOrDefault("eventSubscriptionName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "eventSubscriptionName", valid_568570
  var valid_568571 = path.getOrDefault("scope")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "scope", valid_568571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568572 = query.getOrDefault("api-version")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "api-version", valid_568572
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

proc call*(call_568574: Call_EventSubscriptionsUpdate_568567; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates an existing event subscription.
  ## 
  let valid = call_568574.validator(path, query, header, formData, body)
  let scheme = call_568574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568574.url(scheme.get, call_568574.host, call_568574.base,
                         call_568574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568574, url, valid)

proc call*(call_568575: Call_EventSubscriptionsUpdate_568567; apiVersion: string;
          eventSubscriptionName: string; scope: string;
          eventSubscriptionUpdateParameters: JsonNode): Recallable =
  ## eventSubscriptionsUpdate
  ## Asynchronously updates an existing event subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription to be updated
  ##   scope: string (required)
  ##        : The scope of existing event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  ##   eventSubscriptionUpdateParameters: JObject (required)
  ##                                    : Updated event subscription information
  var path_568576 = newJObject()
  var query_568577 = newJObject()
  var body_568578 = newJObject()
  add(query_568577, "api-version", newJString(apiVersion))
  add(path_568576, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568576, "scope", newJString(scope))
  if eventSubscriptionUpdateParameters != nil:
    body_568578 = eventSubscriptionUpdateParameters
  result = call_568575.call(path_568576, query_568577, nil, nil, body_568578)

var eventSubscriptionsUpdate* = Call_EventSubscriptionsUpdate_568567(
    name: "eventSubscriptionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsUpdate_568568, base: "",
    url: url_EventSubscriptionsUpdate_568569, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsDelete_568557 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsDelete_568559(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsDelete_568558(path: JsonNode; query: JsonNode;
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
  var valid_568560 = path.getOrDefault("eventSubscriptionName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "eventSubscriptionName", valid_568560
  var valid_568561 = path.getOrDefault("scope")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "scope", valid_568561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568562 = query.getOrDefault("api-version")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "api-version", valid_568562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_EventSubscriptionsDelete_568557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing event subscription
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_EventSubscriptionsDelete_568557; apiVersion: string;
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
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568565, "scope", newJString(scope))
  result = call_568564.call(path_568565, query_568566, nil, nil, nil)

var eventSubscriptionsDelete* = Call_EventSubscriptionsDelete_568557(
    name: "eventSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsDelete_568558, base: "",
    url: url_EventSubscriptionsDelete_568559, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGetFullUrl_568579 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsGetFullUrl_568581(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsGetFullUrl_568580(path: JsonNode; query: JsonNode;
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
  var valid_568582 = path.getOrDefault("eventSubscriptionName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "eventSubscriptionName", valid_568582
  var valid_568583 = path.getOrDefault("scope")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "scope", valid_568583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568584 = query.getOrDefault("api-version")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "api-version", valid_568584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568585: Call_EventSubscriptionsGetFullUrl_568579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the full endpoint URL for an event subscription
  ## 
  let valid = call_568585.validator(path, query, header, formData, body)
  let scheme = call_568585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568585.url(scheme.get, call_568585.host, call_568585.base,
                         call_568585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568585, url, valid)

proc call*(call_568586: Call_EventSubscriptionsGetFullUrl_568579;
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
  var path_568587 = newJObject()
  var query_568588 = newJObject()
  add(query_568588, "api-version", newJString(apiVersion))
  add(path_568587, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568587, "scope", newJString(scope))
  result = call_568586.call(path_568587, query_568588, nil, nil, nil)

var eventSubscriptionsGetFullUrl* = Call_EventSubscriptionsGetFullUrl_568579(
    name: "eventSubscriptionsGetFullUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}/getFullUrl",
    validator: validate_EventSubscriptionsGetFullUrl_568580, base: "",
    url: url_EventSubscriptionsGetFullUrl_568581, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
