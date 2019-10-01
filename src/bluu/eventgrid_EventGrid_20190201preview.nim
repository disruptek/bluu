
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventGridManagementClient
## version: 2019-02-01-preview
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
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  var valid_568214 = query.getOrDefault("$top")
  valid_568214 = validateParameter(valid_568214, JInt, required = false, default = nil)
  if valid_568214 != nil:
    section.add "$top", valid_568214
  var valid_568215 = query.getOrDefault("$filter")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "$filter", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_DomainsListBySubscription_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the domains under an Azure subscription
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_DomainsListBySubscription_568208; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## domainsListBySubscription
  ## List all the domains under an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(query_568219, "$top", newJInt(Top))
  add(query_568219, "$filter", newJString(Filter))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var domainsListBySubscription* = Call_DomainsListBySubscription_568208(
    name: "domainsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/domains",
    validator: validate_DomainsListBySubscription_568209, base: "",
    url: url_DomainsListBySubscription_568210, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscription_568220 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalBySubscription_568222(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalBySubscription_568221(path: JsonNode;
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
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568224 = query.getOrDefault("label")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "label", valid_568224
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  var valid_568226 = query.getOrDefault("$top")
  valid_568226 = validateParameter(valid_568226, JInt, required = false, default = nil)
  if valid_568226 != nil:
    section.add "$top", valid_568226
  var valid_568227 = query.getOrDefault("$filter")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "$filter", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_EventSubscriptionsListGlobalBySubscription_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_EventSubscriptionsListGlobalBySubscription_568220;
          apiVersion: string; subscriptionId: string; label: string = ""; Top: int = 0;
          Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalBySubscription
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(query_568231, "label", newJString(label))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(query_568231, "$top", newJInt(Top))
  add(query_568231, "$filter", newJString(Filter))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscription* = Call_EventSubscriptionsListGlobalBySubscription_568220(
    name: "eventSubscriptionsListGlobalBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscription_568221,
    base: "", url: url_EventSubscriptionsListGlobalBySubscription_568222,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscription_568232 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalBySubscription_568234(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalBySubscription_568233(path: JsonNode;
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
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  var valid_568236 = path.getOrDefault("location")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "location", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568237 = query.getOrDefault("label")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "label", valid_568237
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  var valid_568239 = query.getOrDefault("$top")
  valid_568239 = validateParameter(valid_568239, JInt, required = false, default = nil)
  if valid_568239 != nil:
    section.add "$top", valid_568239
  var valid_568240 = query.getOrDefault("$filter")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "$filter", valid_568240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_EventSubscriptionsListRegionalBySubscription_568232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_EventSubscriptionsListRegionalBySubscription_568232;
          apiVersion: string; subscriptionId: string; location: string;
          label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalBySubscription
  ## List all event subscriptions from the given location under a specific Azure subscription
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   location: string (required)
  ##           : Name of the location
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  add(query_568244, "label", newJString(label))
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "subscriptionId", newJString(subscriptionId))
  add(query_568244, "$top", newJInt(Top))
  add(path_568243, "location", newJString(location))
  add(query_568244, "$filter", newJString(Filter))
  result = call_568242.call(path_568243, query_568244, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscription* = Call_EventSubscriptionsListRegionalBySubscription_568232(
    name: "eventSubscriptionsListRegionalBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalBySubscription_568233,
    base: "", url: url_EventSubscriptionsListRegionalBySubscription_568234,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568245 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568247(
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

proc validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568246(
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
  var valid_568248 = path.getOrDefault("topicTypeName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "topicTypeName", valid_568248
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  var valid_568250 = path.getOrDefault("location")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "location", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568251 = query.getOrDefault("label")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "label", valid_568251
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  var valid_568253 = query.getOrDefault("$top")
  valid_568253 = validateParameter(valid_568253, JInt, required = false, default = nil)
  if valid_568253 != nil:
    section.add "$top", valid_568253
  var valid_568254 = query.getOrDefault("$filter")
  valid_568254 = validateParameter(valid_568254, JString, required = false,
                                 default = nil)
  if valid_568254 != nil:
    section.add "$filter", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568245;
          topicTypeName: string; apiVersion: string; subscriptionId: string;
          location: string; label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalBySubscriptionForTopicType
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   location: string (required)
  ##           : Name of the location
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "topicTypeName", newJString(topicTypeName))
  add(query_568258, "label", newJString(label))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(query_568258, "$top", newJInt(Top))
  add(path_568257, "location", newJString(location))
  add(query_568258, "$filter", newJString(Filter))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscriptionForTopicType* = Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568245(
    name: "eventSubscriptionsListRegionalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568246,
    base: "", url: url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568247,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568259 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568261(
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

proc validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568260(
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
  var valid_568262 = path.getOrDefault("topicTypeName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "topicTypeName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568264 = query.getOrDefault("label")
  valid_568264 = validateParameter(valid_568264, JString, required = false,
                                 default = nil)
  if valid_568264 != nil:
    section.add "label", valid_568264
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  var valid_568266 = query.getOrDefault("$top")
  valid_568266 = validateParameter(valid_568266, JInt, required = false, default = nil)
  if valid_568266 != nil:
    section.add "$top", valid_568266
  var valid_568267 = query.getOrDefault("$filter")
  valid_568267 = validateParameter(valid_568267, JString, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "$filter", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568259;
          topicTypeName: string; apiVersion: string; subscriptionId: string;
          label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalBySubscriptionForTopicType
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "topicTypeName", newJString(topicTypeName))
  add(query_568271, "label", newJString(label))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  add(query_568271, "$top", newJInt(Top))
  add(query_568271, "$filter", newJString(Filter))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscriptionForTopicType* = Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568259(
    name: "eventSubscriptionsListGlobalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568260,
    base: "", url: url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568261,
    schemes: {Scheme.Https})
type
  Call_TopicsListBySubscription_568272 = ref object of OpenApiRestCall_567651
proc url_TopicsListBySubscription_568274(protocol: Scheme; host: string;
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

proc validate_TopicsListBySubscription_568273(path: JsonNode; query: JsonNode;
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
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  var valid_568277 = query.getOrDefault("$top")
  valid_568277 = validateParameter(valid_568277, JInt, required = false, default = nil)
  if valid_568277 != nil:
    section.add "$top", valid_568277
  var valid_568278 = query.getOrDefault("$filter")
  valid_568278 = validateParameter(valid_568278, JString, required = false,
                                 default = nil)
  if valid_568278 != nil:
    section.add "$filter", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_TopicsListBySubscription_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under an Azure subscription
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_TopicsListBySubscription_568272; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## topicsListBySubscription
  ## List all the topics under an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  add(query_568282, "$top", newJInt(Top))
  add(query_568282, "$filter", newJString(Filter))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var topicsListBySubscription* = Call_TopicsListBySubscription_568272(
    name: "topicsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListBySubscription_568273, base: "",
    url: url_TopicsListBySubscription_568274, schemes: {Scheme.Https})
type
  Call_DomainsListByResourceGroup_568283 = ref object of OpenApiRestCall_567651
proc url_DomainsListByResourceGroup_568285(protocol: Scheme; host: string;
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

proc validate_DomainsListByResourceGroup_568284(path: JsonNode; query: JsonNode;
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
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("subscriptionId")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "subscriptionId", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  var valid_568289 = query.getOrDefault("$top")
  valid_568289 = validateParameter(valid_568289, JInt, required = false, default = nil)
  if valid_568289 != nil:
    section.add "$top", valid_568289
  var valid_568290 = query.getOrDefault("$filter")
  valid_568290 = validateParameter(valid_568290, JString, required = false,
                                 default = nil)
  if valid_568290 != nil:
    section.add "$filter", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_DomainsListByResourceGroup_568283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the domains under a resource group
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_DomainsListByResourceGroup_568283;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## domainsListByResourceGroup
  ## List all the domains under a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(query_568294, "$top", newJInt(Top))
  add(query_568294, "$filter", newJString(Filter))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var domainsListByResourceGroup* = Call_DomainsListByResourceGroup_568283(
    name: "domainsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains",
    validator: validate_DomainsListByResourceGroup_568284, base: "",
    url: url_DomainsListByResourceGroup_568285, schemes: {Scheme.Https})
type
  Call_DomainsCreateOrUpdate_568306 = ref object of OpenApiRestCall_567651
proc url_DomainsCreateOrUpdate_568308(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsCreateOrUpdate_568307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates or updates a new domain with the specified parameters.
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
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("domainName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "domainName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
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

proc call*(call_568314: Call_DomainsCreateOrUpdate_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates or updates a new domain with the specified parameters.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_DomainsCreateOrUpdate_568306;
          resourceGroupName: string; domainInfo: JsonNode; apiVersion: string;
          subscriptionId: string; domainName: string): Recallable =
  ## domainsCreateOrUpdate
  ## Asynchronously creates or updates a new domain with the specified parameters.
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
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  var body_568318 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  if domainInfo != nil:
    body_568318 = domainInfo
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "domainName", newJString(domainName))
  result = call_568315.call(path_568316, query_568317, nil, nil, body_568318)

var domainsCreateOrUpdate* = Call_DomainsCreateOrUpdate_568306(
    name: "domainsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsCreateOrUpdate_568307, base: "",
    url: url_DomainsCreateOrUpdate_568308, schemes: {Scheme.Https})
type
  Call_DomainsGet_568295 = ref object of OpenApiRestCall_567651
proc url_DomainsGet_568297(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DomainsGet_568296(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("domainName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "domainName", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_DomainsGet_568295; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a domain
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_DomainsGet_568295; resourceGroupName: string;
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
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "domainName", newJString(domainName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var domainsGet* = Call_DomainsGet_568295(name: "domainsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
                                      validator: validate_DomainsGet_568296,
                                      base: "", url: url_DomainsGet_568297,
                                      schemes: {Scheme.Https})
type
  Call_DomainsUpdate_568330 = ref object of OpenApiRestCall_567651
proc url_DomainsUpdate_568332(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsUpdate_568331(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  var valid_568335 = path.getOrDefault("domainName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "domainName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
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

proc call*(call_568338: Call_DomainsUpdate_568330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a domain with the specified parameters.
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_DomainsUpdate_568330; resourceGroupName: string;
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
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  var body_568342 = newJObject()
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  if domainUpdateParameters != nil:
    body_568342 = domainUpdateParameters
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  add(path_568340, "domainName", newJString(domainName))
  result = call_568339.call(path_568340, query_568341, nil, nil, body_568342)

var domainsUpdate* = Call_DomainsUpdate_568330(name: "domainsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsUpdate_568331, base: "", url: url_DomainsUpdate_568332,
    schemes: {Scheme.Https})
type
  Call_DomainsDelete_568319 = ref object of OpenApiRestCall_567651
proc url_DomainsDelete_568321(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsDelete_568320(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  var valid_568324 = path.getOrDefault("domainName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "domainName", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_DomainsDelete_568319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing domain
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_DomainsDelete_568319; resourceGroupName: string;
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
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "domainName", newJString(domainName))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var domainsDelete* = Call_DomainsDelete_568319(name: "domainsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsDelete_568320, base: "", url: url_DomainsDelete_568321,
    schemes: {Scheme.Https})
type
  Call_DomainsListSharedAccessKeys_568343 = ref object of OpenApiRestCall_567651
proc url_DomainsListSharedAccessKeys_568345(protocol: Scheme; host: string;
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

proc validate_DomainsListSharedAccessKeys_568344(path: JsonNode; query: JsonNode;
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
  var valid_568346 = path.getOrDefault("resourceGroupName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceGroupName", valid_568346
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  var valid_568348 = path.getOrDefault("domainName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "domainName", valid_568348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568349 = query.getOrDefault("api-version")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "api-version", valid_568349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_DomainsListSharedAccessKeys_568343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a domain
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_DomainsListSharedAccessKeys_568343;
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
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(path_568352, "domainName", newJString(domainName))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var domainsListSharedAccessKeys* = Call_DomainsListSharedAccessKeys_568343(
    name: "domainsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/listKeys",
    validator: validate_DomainsListSharedAccessKeys_568344, base: "",
    url: url_DomainsListSharedAccessKeys_568345, schemes: {Scheme.Https})
type
  Call_DomainsRegenerateKey_568354 = ref object of OpenApiRestCall_567651
proc url_DomainsRegenerateKey_568356(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsRegenerateKey_568355(path: JsonNode; query: JsonNode;
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
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("subscriptionId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "subscriptionId", valid_568358
  var valid_568359 = path.getOrDefault("domainName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "domainName", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568360 = query.getOrDefault("api-version")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "api-version", valid_568360
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

proc call*(call_568362: Call_DomainsRegenerateKey_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a domain
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_DomainsRegenerateKey_568354;
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
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  var body_568366 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "domainName", newJString(domainName))
  if regenerateKeyRequest != nil:
    body_568366 = regenerateKeyRequest
  result = call_568363.call(path_568364, query_568365, nil, nil, body_568366)

var domainsRegenerateKey* = Call_DomainsRegenerateKey_568354(
    name: "domainsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/regenerateKey",
    validator: validate_DomainsRegenerateKey_568355, base: "",
    url: url_DomainsRegenerateKey_568356, schemes: {Scheme.Https})
type
  Call_DomainTopicsListByDomain_568367 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsListByDomain_568369(protocol: Scheme; host: string;
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

proc validate_DomainTopicsListByDomain_568368(path: JsonNode; query: JsonNode;
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
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("domainName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "domainName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  var valid_568374 = query.getOrDefault("$top")
  valid_568374 = validateParameter(valid_568374, JInt, required = false, default = nil)
  if valid_568374 != nil:
    section.add "$top", valid_568374
  var valid_568375 = query.getOrDefault("$filter")
  valid_568375 = validateParameter(valid_568375, JString, required = false,
                                 default = nil)
  if valid_568375 != nil:
    section.add "$filter", valid_568375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_DomainTopicsListByDomain_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics in a domain.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_DomainTopicsListByDomain_568367;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## domainTopicsListByDomain
  ## List all the topics in a domain.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   domainName: string (required)
  ##             : Domain name.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  add(query_568379, "$top", newJInt(Top))
  add(path_568378, "domainName", newJString(domainName))
  add(query_568379, "$filter", newJString(Filter))
  result = call_568377.call(path_568378, query_568379, nil, nil, nil)

var domainTopicsListByDomain* = Call_DomainTopicsListByDomain_568367(
    name: "domainTopicsListByDomain", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics",
    validator: validate_DomainTopicsListByDomain_568368, base: "",
    url: url_DomainTopicsListByDomain_568369, schemes: {Scheme.Https})
type
  Call_DomainTopicsCreateOrUpdate_568392 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsCreateOrUpdate_568394(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  assert "domainTopicName" in path, "`domainTopicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "domainTopicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainTopicsCreateOrUpdate_568393(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates or updates a new domain topic with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: JString (required)
  ##                  : Name of the domain topic
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  var valid_568397 = path.getOrDefault("domainTopicName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "domainTopicName", valid_568397
  var valid_568398 = path.getOrDefault("domainName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "domainName", valid_568398
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

proc call*(call_568400: Call_DomainTopicsCreateOrUpdate_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates or updates a new domain topic with the specified parameters.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_DomainTopicsCreateOrUpdate_568392;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainTopicName: string; domainName: string): Recallable =
  ## domainTopicsCreateOrUpdate
  ## Asynchronously creates or updates a new domain topic with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: string (required)
  ##                  : Name of the domain topic
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  add(path_568402, "domainTopicName", newJString(domainTopicName))
  add(path_568402, "domainName", newJString(domainName))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var domainTopicsCreateOrUpdate* = Call_DomainTopicsCreateOrUpdate_568392(
    name: "domainTopicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{domainTopicName}",
    validator: validate_DomainTopicsCreateOrUpdate_568393, base: "",
    url: url_DomainTopicsCreateOrUpdate_568394, schemes: {Scheme.Https})
type
  Call_DomainTopicsGet_568380 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsGet_568382(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  assert "domainTopicName" in path, "`domainTopicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "domainTopicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainTopicsGet_568381(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get properties of a domain topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: JString (required)
  ##                  : Name of the topic
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("domainTopicName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "domainTopicName", valid_568385
  var valid_568386 = path.getOrDefault("domainName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "domainName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_DomainTopicsGet_568380; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a domain topic
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_DomainTopicsGet_568380; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainTopicName: string;
          domainName: string): Recallable =
  ## domainTopicsGet
  ## Get properties of a domain topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: string (required)
  ##                  : Name of the topic
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "domainTopicName", newJString(domainTopicName))
  add(path_568390, "domainName", newJString(domainName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var domainTopicsGet* = Call_DomainTopicsGet_568380(name: "domainTopicsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{domainTopicName}",
    validator: validate_DomainTopicsGet_568381, base: "", url: url_DomainTopicsGet_568382,
    schemes: {Scheme.Https})
type
  Call_DomainTopicsDelete_568404 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsDelete_568406(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  assert "domainTopicName" in path, "`domainTopicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/domains/"),
               (kind: VariableSegment, value: "domainName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "domainTopicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainTopicsDelete_568405(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete existing domain topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: JString (required)
  ##                  : Name of the domain topic
  ##   domainName: JString (required)
  ##             : Name of the domain
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("subscriptionId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "subscriptionId", valid_568408
  var valid_568409 = path.getOrDefault("domainTopicName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "domainTopicName", valid_568409
  var valid_568410 = path.getOrDefault("domainName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "domainName", valid_568410
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

proc call*(call_568412: Call_DomainTopicsDelete_568404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing domain topic
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_DomainTopicsDelete_568404; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainTopicName: string;
          domainName: string): Recallable =
  ## domainTopicsDelete
  ## Delete existing domain topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: string (required)
  ##                  : Name of the domain topic
  ##   domainName: string (required)
  ##             : Name of the domain
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "domainTopicName", newJString(domainTopicName))
  add(path_568414, "domainName", newJString(domainName))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var domainTopicsDelete* = Call_DomainTopicsDelete_568404(
    name: "domainTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{domainTopicName}",
    validator: validate_DomainTopicsDelete_568405, base: "",
    url: url_DomainTopicsDelete_568406, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByDomainTopic_568416 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListByDomainTopic_568418(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsListByDomainTopic_568417(path: JsonNode;
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
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("topicName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "topicName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  var valid_568422 = path.getOrDefault("domainName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "domainName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568423 = query.getOrDefault("label")
  valid_568423 = validateParameter(valid_568423, JString, required = false,
                                 default = nil)
  if valid_568423 != nil:
    section.add "label", valid_568423
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  var valid_568425 = query.getOrDefault("$top")
  valid_568425 = validateParameter(valid_568425, JInt, required = false, default = nil)
  if valid_568425 != nil:
    section.add "$top", valid_568425
  var valid_568426 = query.getOrDefault("$filter")
  valid_568426 = validateParameter(valid_568426, JString, required = false,
                                 default = nil)
  if valid_568426 != nil:
    section.add "$filter", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_EventSubscriptionsListByDomainTopic_568416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific domain topic
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_EventSubscriptionsListByDomainTopic_568416;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; domainName: string; label: string = ""; Top: int = 0;
          Filter: string = ""): Recallable =
  ## eventSubscriptionsListByDomainTopic
  ## List all event subscriptions that have been created for a specific domain topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the domain topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   domainName: string (required)
  ##             : Name of the top level domain
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "label", newJString(label))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "topicName", newJString(topicName))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(query_568430, "$top", newJInt(Top))
  add(path_568429, "domainName", newJString(domainName))
  add(query_568430, "$filter", newJString(Filter))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var eventSubscriptionsListByDomainTopic* = Call_EventSubscriptionsListByDomainTopic_568416(
    name: "eventSubscriptionsListByDomainTopic", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{topicName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByDomainTopic_568417, base: "",
    url: url_EventSubscriptionsListByDomainTopic_568418, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroup_568431 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalByResourceGroup_568433(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalByResourceGroup_568432(path: JsonNode;
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
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568436 = query.getOrDefault("label")
  valid_568436 = validateParameter(valid_568436, JString, required = false,
                                 default = nil)
  if valid_568436 != nil:
    section.add "label", valid_568436
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  var valid_568438 = query.getOrDefault("$top")
  valid_568438 = validateParameter(valid_568438, JInt, required = false, default = nil)
  if valid_568438 != nil:
    section.add "$top", valid_568438
  var valid_568439 = query.getOrDefault("$filter")
  valid_568439 = validateParameter(valid_568439, JString, required = false,
                                 default = nil)
  if valid_568439 != nil:
    section.add "$filter", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_EventSubscriptionsListGlobalByResourceGroup_568431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_EventSubscriptionsListGlobalByResourceGroup_568431;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroup
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "label", newJString(label))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  add(query_568443, "$top", newJInt(Top))
  add(query_568443, "$filter", newJString(Filter))
  result = call_568441.call(path_568442, query_568443, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroup* = Call_EventSubscriptionsListGlobalByResourceGroup_568431(
    name: "eventSubscriptionsListGlobalByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalByResourceGroup_568432,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroup_568433,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroup_568444 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalByResourceGroup_568446(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalByResourceGroup_568445(
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
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("location")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "location", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568450 = query.getOrDefault("label")
  valid_568450 = validateParameter(valid_568450, JString, required = false,
                                 default = nil)
  if valid_568450 != nil:
    section.add "label", valid_568450
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568451 = query.getOrDefault("api-version")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "api-version", valid_568451
  var valid_568452 = query.getOrDefault("$top")
  valid_568452 = validateParameter(valid_568452, JInt, required = false, default = nil)
  if valid_568452 != nil:
    section.add "$top", valid_568452
  var valid_568453 = query.getOrDefault("$filter")
  valid_568453 = validateParameter(valid_568453, JString, required = false,
                                 default = nil)
  if valid_568453 != nil:
    section.add "$filter", valid_568453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_EventSubscriptionsListRegionalByResourceGroup_568444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_EventSubscriptionsListRegionalByResourceGroup_568444;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          location: string; label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalByResourceGroup
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   location: string (required)
  ##           : Name of the location
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  add(path_568456, "resourceGroupName", newJString(resourceGroupName))
  add(query_568457, "label", newJString(label))
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  add(query_568457, "$top", newJInt(Top))
  add(path_568456, "location", newJString(location))
  add(query_568457, "$filter", newJString(Filter))
  result = call_568455.call(path_568456, query_568457, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroup* = Call_EventSubscriptionsListRegionalByResourceGroup_568444(
    name: "eventSubscriptionsListRegionalByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalByResourceGroup_568445,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroup_568446,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568458 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568460(
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

proc validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568459(
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
  var valid_568461 = path.getOrDefault("topicTypeName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "topicTypeName", valid_568461
  var valid_568462 = path.getOrDefault("resourceGroupName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "resourceGroupName", valid_568462
  var valid_568463 = path.getOrDefault("subscriptionId")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "subscriptionId", valid_568463
  var valid_568464 = path.getOrDefault("location")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "location", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568465 = query.getOrDefault("label")
  valid_568465 = validateParameter(valid_568465, JString, required = false,
                                 default = nil)
  if valid_568465 != nil:
    section.add "label", valid_568465
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
  var valid_568467 = query.getOrDefault("$top")
  valid_568467 = validateParameter(valid_568467, JInt, required = false, default = nil)
  if valid_568467 != nil:
    section.add "$top", valid_568467
  var valid_568468 = query.getOrDefault("$filter")
  valid_568468 = validateParameter(valid_568468, JString, required = false,
                                 default = nil)
  if valid_568468 != nil:
    section.add "$filter", valid_568468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568469: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ## 
  let valid = call_568469.validator(path, query, header, formData, body)
  let scheme = call_568469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568469.url(scheme.get, call_568469.host, call_568469.base,
                         call_568469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568469, url, valid)

proc call*(call_568470: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568458;
          topicTypeName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; location: string; label: string = ""; Top: int = 0;
          Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalByResourceGroupForTopicType
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   location: string (required)
  ##           : Name of the location
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568471 = newJObject()
  var query_568472 = newJObject()
  add(path_568471, "topicTypeName", newJString(topicTypeName))
  add(path_568471, "resourceGroupName", newJString(resourceGroupName))
  add(query_568472, "label", newJString(label))
  add(query_568472, "api-version", newJString(apiVersion))
  add(path_568471, "subscriptionId", newJString(subscriptionId))
  add(query_568472, "$top", newJInt(Top))
  add(path_568471, "location", newJString(location))
  add(query_568472, "$filter", newJString(Filter))
  result = call_568470.call(path_568471, query_568472, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroupForTopicType* = Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568458(
    name: "eventSubscriptionsListRegionalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568459,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568460,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568473 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568475(
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

proc validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568474(
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
  var valid_568476 = path.getOrDefault("topicTypeName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "topicTypeName", valid_568476
  var valid_568477 = path.getOrDefault("resourceGroupName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "resourceGroupName", valid_568477
  var valid_568478 = path.getOrDefault("subscriptionId")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "subscriptionId", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568479 = query.getOrDefault("label")
  valid_568479 = validateParameter(valid_568479, JString, required = false,
                                 default = nil)
  if valid_568479 != nil:
    section.add "label", valid_568479
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568480 = query.getOrDefault("api-version")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "api-version", valid_568480
  var valid_568481 = query.getOrDefault("$top")
  valid_568481 = validateParameter(valid_568481, JInt, required = false, default = nil)
  if valid_568481 != nil:
    section.add "$top", valid_568481
  var valid_568482 = query.getOrDefault("$filter")
  valid_568482 = validateParameter(valid_568482, JString, required = false,
                                 default = nil)
  if valid_568482 != nil:
    section.add "$filter", valid_568482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568483: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568473;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  let valid = call_568483.validator(path, query, header, formData, body)
  let scheme = call_568483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568483.url(scheme.get, call_568483.host, call_568483.base,
                         call_568483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568483, url, valid)

proc call*(call_568484: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568473;
          topicTypeName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroupForTopicType
  ## List all global event subscriptions under a resource group for a specific topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568485 = newJObject()
  var query_568486 = newJObject()
  add(path_568485, "topicTypeName", newJString(topicTypeName))
  add(path_568485, "resourceGroupName", newJString(resourceGroupName))
  add(query_568486, "label", newJString(label))
  add(query_568486, "api-version", newJString(apiVersion))
  add(path_568485, "subscriptionId", newJString(subscriptionId))
  add(query_568486, "$top", newJInt(Top))
  add(query_568486, "$filter", newJString(Filter))
  result = call_568484.call(path_568485, query_568486, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroupForTopicType* = Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568473(
    name: "eventSubscriptionsListGlobalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568474,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568475,
    schemes: {Scheme.Https})
type
  Call_TopicsListByResourceGroup_568487 = ref object of OpenApiRestCall_567651
proc url_TopicsListByResourceGroup_568489(protocol: Scheme; host: string;
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

proc validate_TopicsListByResourceGroup_568488(path: JsonNode; query: JsonNode;
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
  var valid_568490 = path.getOrDefault("resourceGroupName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "resourceGroupName", valid_568490
  var valid_568491 = path.getOrDefault("subscriptionId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "subscriptionId", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
  var valid_568493 = query.getOrDefault("$top")
  valid_568493 = validateParameter(valid_568493, JInt, required = false, default = nil)
  if valid_568493 != nil:
    section.add "$top", valid_568493
  var valid_568494 = query.getOrDefault("$filter")
  valid_568494 = validateParameter(valid_568494, JString, required = false,
                                 default = nil)
  if valid_568494 != nil:
    section.add "$filter", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_TopicsListByResourceGroup_568487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under a resource group
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_TopicsListByResourceGroup_568487;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## topicsListByResourceGroup
  ## List all the topics under a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(query_568498, "$top", newJInt(Top))
  add(query_568498, "$filter", newJString(Filter))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var topicsListByResourceGroup* = Call_TopicsListByResourceGroup_568487(
    name: "topicsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListByResourceGroup_568488, base: "",
    url: url_TopicsListByResourceGroup_568489, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568510 = ref object of OpenApiRestCall_567651
proc url_TopicsCreateOrUpdate_568512(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsCreateOrUpdate_568511(path: JsonNode; query: JsonNode;
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
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("topicName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "topicName", valid_568514
  var valid_568515 = path.getOrDefault("subscriptionId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "subscriptionId", valid_568515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568516 = query.getOrDefault("api-version")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "api-version", valid_568516
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

proc call*(call_568518: Call_TopicsCreateOrUpdate_568510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  let valid = call_568518.validator(path, query, header, formData, body)
  let scheme = call_568518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568518.url(scheme.get, call_568518.host, call_568518.base,
                         call_568518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568518, url, valid)

proc call*(call_568519: Call_TopicsCreateOrUpdate_568510;
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
  var path_568520 = newJObject()
  var query_568521 = newJObject()
  var body_568522 = newJObject()
  add(path_568520, "resourceGroupName", newJString(resourceGroupName))
  add(query_568521, "api-version", newJString(apiVersion))
  add(path_568520, "topicName", newJString(topicName))
  add(path_568520, "subscriptionId", newJString(subscriptionId))
  if topicInfo != nil:
    body_568522 = topicInfo
  result = call_568519.call(path_568520, query_568521, nil, nil, body_568522)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568510(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568511, base: "",
    url: url_TopicsCreateOrUpdate_568512, schemes: {Scheme.Https})
type
  Call_TopicsGet_568499 = ref object of OpenApiRestCall_567651
proc url_TopicsGet_568501(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TopicsGet_568500(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568502 = path.getOrDefault("resourceGroupName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "resourceGroupName", valid_568502
  var valid_568503 = path.getOrDefault("topicName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "topicName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_TopicsGet_568499; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a topic
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_TopicsGet_568499; resourceGroupName: string;
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
  var path_568508 = newJObject()
  var query_568509 = newJObject()
  add(path_568508, "resourceGroupName", newJString(resourceGroupName))
  add(query_568509, "api-version", newJString(apiVersion))
  add(path_568508, "topicName", newJString(topicName))
  add(path_568508, "subscriptionId", newJString(subscriptionId))
  result = call_568507.call(path_568508, query_568509, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568499(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
                                    validator: validate_TopicsGet_568500,
                                    base: "", url: url_TopicsGet_568501,
                                    schemes: {Scheme.Https})
type
  Call_TopicsUpdate_568534 = ref object of OpenApiRestCall_567651
proc url_TopicsUpdate_568536(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsUpdate_568535(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568537 = path.getOrDefault("resourceGroupName")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "resourceGroupName", valid_568537
  var valid_568538 = path.getOrDefault("topicName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "topicName", valid_568538
  var valid_568539 = path.getOrDefault("subscriptionId")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "subscriptionId", valid_568539
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
  ## parameters in `body` object:
  ##   topicUpdateParameters: JObject (required)
  ##                        : Topic update information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568542: Call_TopicsUpdate_568534; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a topic with the specified parameters.
  ## 
  let valid = call_568542.validator(path, query, header, formData, body)
  let scheme = call_568542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568542.url(scheme.get, call_568542.host, call_568542.base,
                         call_568542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568542, url, valid)

proc call*(call_568543: Call_TopicsUpdate_568534; resourceGroupName: string;
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
  var path_568544 = newJObject()
  var query_568545 = newJObject()
  var body_568546 = newJObject()
  add(path_568544, "resourceGroupName", newJString(resourceGroupName))
  add(query_568545, "api-version", newJString(apiVersion))
  add(path_568544, "topicName", newJString(topicName))
  add(path_568544, "subscriptionId", newJString(subscriptionId))
  if topicUpdateParameters != nil:
    body_568546 = topicUpdateParameters
  result = call_568543.call(path_568544, query_568545, nil, nil, body_568546)

var topicsUpdate* = Call_TopicsUpdate_568534(name: "topicsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsUpdate_568535, base: "", url: url_TopicsUpdate_568536,
    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568523 = ref object of OpenApiRestCall_567651
proc url_TopicsDelete_568525(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsDelete_568524(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568526 = path.getOrDefault("resourceGroupName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "resourceGroupName", valid_568526
  var valid_568527 = path.getOrDefault("topicName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "topicName", valid_568527
  var valid_568528 = path.getOrDefault("subscriptionId")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "subscriptionId", valid_568528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568529 = query.getOrDefault("api-version")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "api-version", valid_568529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568530: Call_TopicsDelete_568523; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing topic
  ## 
  let valid = call_568530.validator(path, query, header, formData, body)
  let scheme = call_568530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568530.url(scheme.get, call_568530.host, call_568530.base,
                         call_568530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568530, url, valid)

proc call*(call_568531: Call_TopicsDelete_568523; resourceGroupName: string;
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
  var path_568532 = newJObject()
  var query_568533 = newJObject()
  add(path_568532, "resourceGroupName", newJString(resourceGroupName))
  add(query_568533, "api-version", newJString(apiVersion))
  add(path_568532, "topicName", newJString(topicName))
  add(path_568532, "subscriptionId", newJString(subscriptionId))
  result = call_568531.call(path_568532, query_568533, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568523(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsDelete_568524, base: "", url: url_TopicsDelete_568525,
    schemes: {Scheme.Https})
type
  Call_TopicsListSharedAccessKeys_568547 = ref object of OpenApiRestCall_567651
proc url_TopicsListSharedAccessKeys_568549(protocol: Scheme; host: string;
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

proc validate_TopicsListSharedAccessKeys_568548(path: JsonNode; query: JsonNode;
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
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("topicName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "topicName", valid_568551
  var valid_568552 = path.getOrDefault("subscriptionId")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "subscriptionId", valid_568552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568553 = query.getOrDefault("api-version")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "api-version", valid_568553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568554: Call_TopicsListSharedAccessKeys_568547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a topic
  ## 
  let valid = call_568554.validator(path, query, header, formData, body)
  let scheme = call_568554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568554.url(scheme.get, call_568554.host, call_568554.base,
                         call_568554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568554, url, valid)

proc call*(call_568555: Call_TopicsListSharedAccessKeys_568547;
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
  var path_568556 = newJObject()
  var query_568557 = newJObject()
  add(path_568556, "resourceGroupName", newJString(resourceGroupName))
  add(query_568557, "api-version", newJString(apiVersion))
  add(path_568556, "topicName", newJString(topicName))
  add(path_568556, "subscriptionId", newJString(subscriptionId))
  result = call_568555.call(path_568556, query_568557, nil, nil, nil)

var topicsListSharedAccessKeys* = Call_TopicsListSharedAccessKeys_568547(
    name: "topicsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/listKeys",
    validator: validate_TopicsListSharedAccessKeys_568548, base: "",
    url: url_TopicsListSharedAccessKeys_568549, schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKey_568558 = ref object of OpenApiRestCall_567651
proc url_TopicsRegenerateKey_568560(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsRegenerateKey_568559(path: JsonNode; query: JsonNode;
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
  var valid_568561 = path.getOrDefault("resourceGroupName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "resourceGroupName", valid_568561
  var valid_568562 = path.getOrDefault("topicName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "topicName", valid_568562
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
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

proc call*(call_568566: Call_TopicsRegenerateKey_568558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a topic
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_TopicsRegenerateKey_568558; resourceGroupName: string;
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
  var path_568568 = newJObject()
  var query_568569 = newJObject()
  var body_568570 = newJObject()
  add(path_568568, "resourceGroupName", newJString(resourceGroupName))
  add(query_568569, "api-version", newJString(apiVersion))
  add(path_568568, "topicName", newJString(topicName))
  add(path_568568, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyRequest != nil:
    body_568570 = regenerateKeyRequest
  result = call_568567.call(path_568568, query_568569, nil, nil, body_568570)

var topicsRegenerateKey* = Call_TopicsRegenerateKey_568558(
    name: "topicsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/regenerateKey",
    validator: validate_TopicsRegenerateKey_568559, base: "",
    url: url_TopicsRegenerateKey_568560, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByResource_568571 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListByResource_568573(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsListByResource_568572(path: JsonNode;
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
  var valid_568574 = path.getOrDefault("providerNamespace")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "providerNamespace", valid_568574
  var valid_568575 = path.getOrDefault("resourceGroupName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "resourceGroupName", valid_568575
  var valid_568576 = path.getOrDefault("subscriptionId")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "subscriptionId", valid_568576
  var valid_568577 = path.getOrDefault("resourceName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceName", valid_568577
  var valid_568578 = path.getOrDefault("resourceTypeName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "resourceTypeName", valid_568578
  result.add "path", section
  ## parameters in `query` object:
  ##   label: JString
  ##        : The label used to filter the results for event subscriptions list.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return.
  ##   $filter: JString
  ##          : Filter the results using OData syntax.
  section = newJObject()
  var valid_568579 = query.getOrDefault("label")
  valid_568579 = validateParameter(valid_568579, JString, required = false,
                                 default = nil)
  if valid_568579 != nil:
    section.add "label", valid_568579
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568580 = query.getOrDefault("api-version")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "api-version", valid_568580
  var valid_568581 = query.getOrDefault("$top")
  valid_568581 = validateParameter(valid_568581, JInt, required = false, default = nil)
  if valid_568581 != nil:
    section.add "$top", valid_568581
  var valid_568582 = query.getOrDefault("$filter")
  valid_568582 = validateParameter(valid_568582, JString, required = false,
                                 default = nil)
  if valid_568582 != nil:
    section.add "$filter", valid_568582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_EventSubscriptionsListByResource_568571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific topic
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_EventSubscriptionsListByResource_568571;
          providerNamespace: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceTypeName: string;
          label: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListByResource
  ## List all event subscriptions that have been created for a specific topic
  ##   providerNamespace: string (required)
  ##                    : Namespace of the provider of the topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   label: string
  ##        : The label used to filter the results for event subscriptions list.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return.
  ##   resourceName: string (required)
  ##               : Name of the resource
  ##   resourceTypeName: string (required)
  ##                   : Name of the resource type
  ##   Filter: string
  ##         : Filter the results using OData syntax.
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  add(path_568585, "providerNamespace", newJString(providerNamespace))
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "label", newJString(label))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  add(query_568586, "$top", newJInt(Top))
  add(path_568585, "resourceName", newJString(resourceName))
  add(path_568585, "resourceTypeName", newJString(resourceTypeName))
  add(query_568586, "$filter", newJString(Filter))
  result = call_568584.call(path_568585, query_568586, nil, nil, nil)

var eventSubscriptionsListByResource* = Call_EventSubscriptionsListByResource_568571(
    name: "eventSubscriptionsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByResource_568572, base: "",
    url: url_EventSubscriptionsListByResource_568573, schemes: {Scheme.Https})
type
  Call_TopicsListEventTypes_568587 = ref object of OpenApiRestCall_567651
proc url_TopicsListEventTypes_568589(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListEventTypes_568588(path: JsonNode; query: JsonNode;
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
  var valid_568590 = path.getOrDefault("providerNamespace")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "providerNamespace", valid_568590
  var valid_568591 = path.getOrDefault("resourceGroupName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "resourceGroupName", valid_568591
  var valid_568592 = path.getOrDefault("subscriptionId")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "subscriptionId", valid_568592
  var valid_568593 = path.getOrDefault("resourceName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "resourceName", valid_568593
  var valid_568594 = path.getOrDefault("resourceTypeName")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "resourceTypeName", valid_568594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568595 = query.getOrDefault("api-version")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "api-version", valid_568595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568596: Call_TopicsListEventTypes_568587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic
  ## 
  let valid = call_568596.validator(path, query, header, formData, body)
  let scheme = call_568596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568596.url(scheme.get, call_568596.host, call_568596.base,
                         call_568596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568596, url, valid)

proc call*(call_568597: Call_TopicsListEventTypes_568587;
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
  var path_568598 = newJObject()
  var query_568599 = newJObject()
  add(path_568598, "providerNamespace", newJString(providerNamespace))
  add(path_568598, "resourceGroupName", newJString(resourceGroupName))
  add(query_568599, "api-version", newJString(apiVersion))
  add(path_568598, "subscriptionId", newJString(subscriptionId))
  add(path_568598, "resourceName", newJString(resourceName))
  add(path_568598, "resourceTypeName", newJString(resourceTypeName))
  result = call_568597.call(path_568598, query_568599, nil, nil, nil)

var topicsListEventTypes* = Call_TopicsListEventTypes_568587(
    name: "topicsListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventTypes",
    validator: validate_TopicsListEventTypes_568588, base: "",
    url: url_TopicsListEventTypes_568589, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsCreateOrUpdate_568610 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsCreateOrUpdate_568612(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsCreateOrUpdate_568611(path: JsonNode;
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
  var valid_568613 = path.getOrDefault("eventSubscriptionName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "eventSubscriptionName", valid_568613
  var valid_568614 = path.getOrDefault("scope")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "scope", valid_568614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568615 = query.getOrDefault("api-version")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "api-version", valid_568615
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

proc call*(call_568617: Call_EventSubscriptionsCreateOrUpdate_568610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ## 
  let valid = call_568617.validator(path, query, header, formData, body)
  let scheme = call_568617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568617.url(scheme.get, call_568617.host, call_568617.base,
                         call_568617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568617, url, valid)

proc call*(call_568618: Call_EventSubscriptionsCreateOrUpdate_568610;
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
  var path_568619 = newJObject()
  var query_568620 = newJObject()
  var body_568621 = newJObject()
  if eventSubscriptionInfo != nil:
    body_568621 = eventSubscriptionInfo
  add(query_568620, "api-version", newJString(apiVersion))
  add(path_568619, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568619, "scope", newJString(scope))
  result = call_568618.call(path_568619, query_568620, nil, nil, body_568621)

var eventSubscriptionsCreateOrUpdate* = Call_EventSubscriptionsCreateOrUpdate_568610(
    name: "eventSubscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsCreateOrUpdate_568611, base: "",
    url: url_EventSubscriptionsCreateOrUpdate_568612, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGet_568600 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsGet_568602(protocol: Scheme; host: string; base: string;
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

proc validate_EventSubscriptionsGet_568601(path: JsonNode; query: JsonNode;
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
  var valid_568603 = path.getOrDefault("eventSubscriptionName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "eventSubscriptionName", valid_568603
  var valid_568604 = path.getOrDefault("scope")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "scope", valid_568604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568605 = query.getOrDefault("api-version")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "api-version", valid_568605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568606: Call_EventSubscriptionsGet_568600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of an event subscription
  ## 
  let valid = call_568606.validator(path, query, header, formData, body)
  let scheme = call_568606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568606.url(scheme.get, call_568606.host, call_568606.base,
                         call_568606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568606, url, valid)

proc call*(call_568607: Call_EventSubscriptionsGet_568600; apiVersion: string;
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
  var path_568608 = newJObject()
  var query_568609 = newJObject()
  add(query_568609, "api-version", newJString(apiVersion))
  add(path_568608, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568608, "scope", newJString(scope))
  result = call_568607.call(path_568608, query_568609, nil, nil, nil)

var eventSubscriptionsGet* = Call_EventSubscriptionsGet_568600(
    name: "eventSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsGet_568601, base: "",
    url: url_EventSubscriptionsGet_568602, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsUpdate_568632 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsUpdate_568634(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsUpdate_568633(path: JsonNode; query: JsonNode;
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
  var valid_568635 = path.getOrDefault("eventSubscriptionName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "eventSubscriptionName", valid_568635
  var valid_568636 = path.getOrDefault("scope")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "scope", valid_568636
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568637 = query.getOrDefault("api-version")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "api-version", valid_568637
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

proc call*(call_568639: Call_EventSubscriptionsUpdate_568632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates an existing event subscription.
  ## 
  let valid = call_568639.validator(path, query, header, formData, body)
  let scheme = call_568639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568639.url(scheme.get, call_568639.host, call_568639.base,
                         call_568639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568639, url, valid)

proc call*(call_568640: Call_EventSubscriptionsUpdate_568632; apiVersion: string;
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
  var path_568641 = newJObject()
  var query_568642 = newJObject()
  var body_568643 = newJObject()
  add(query_568642, "api-version", newJString(apiVersion))
  add(path_568641, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568641, "scope", newJString(scope))
  if eventSubscriptionUpdateParameters != nil:
    body_568643 = eventSubscriptionUpdateParameters
  result = call_568640.call(path_568641, query_568642, nil, nil, body_568643)

var eventSubscriptionsUpdate* = Call_EventSubscriptionsUpdate_568632(
    name: "eventSubscriptionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsUpdate_568633, base: "",
    url: url_EventSubscriptionsUpdate_568634, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsDelete_568622 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsDelete_568624(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsDelete_568623(path: JsonNode; query: JsonNode;
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
  var valid_568625 = path.getOrDefault("eventSubscriptionName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "eventSubscriptionName", valid_568625
  var valid_568626 = path.getOrDefault("scope")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "scope", valid_568626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568627 = query.getOrDefault("api-version")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "api-version", valid_568627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568628: Call_EventSubscriptionsDelete_568622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing event subscription
  ## 
  let valid = call_568628.validator(path, query, header, formData, body)
  let scheme = call_568628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568628.url(scheme.get, call_568628.host, call_568628.base,
                         call_568628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568628, url, valid)

proc call*(call_568629: Call_EventSubscriptionsDelete_568622; apiVersion: string;
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
  var path_568630 = newJObject()
  var query_568631 = newJObject()
  add(query_568631, "api-version", newJString(apiVersion))
  add(path_568630, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568630, "scope", newJString(scope))
  result = call_568629.call(path_568630, query_568631, nil, nil, nil)

var eventSubscriptionsDelete* = Call_EventSubscriptionsDelete_568622(
    name: "eventSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsDelete_568623, base: "",
    url: url_EventSubscriptionsDelete_568624, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGetFullUrl_568644 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsGetFullUrl_568646(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsGetFullUrl_568645(path: JsonNode; query: JsonNode;
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
  var valid_568647 = path.getOrDefault("eventSubscriptionName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "eventSubscriptionName", valid_568647
  var valid_568648 = path.getOrDefault("scope")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "scope", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568650: Call_EventSubscriptionsGetFullUrl_568644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the full endpoint URL for an event subscription
  ## 
  let valid = call_568650.validator(path, query, header, formData, body)
  let scheme = call_568650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568650.url(scheme.get, call_568650.host, call_568650.base,
                         call_568650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568650, url, valid)

proc call*(call_568651: Call_EventSubscriptionsGetFullUrl_568644;
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
  var path_568652 = newJObject()
  var query_568653 = newJObject()
  add(query_568653, "api-version", newJString(apiVersion))
  add(path_568652, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568652, "scope", newJString(scope))
  result = call_568651.call(path_568652, query_568653, nil, nil, nil)

var eventSubscriptionsGetFullUrl* = Call_EventSubscriptionsGetFullUrl_568644(
    name: "eventSubscriptionsGetFullUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}/getFullUrl",
    validator: validate_EventSubscriptionsGetFullUrl_568645, base: "",
    url: url_EventSubscriptionsGetFullUrl_568646, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
