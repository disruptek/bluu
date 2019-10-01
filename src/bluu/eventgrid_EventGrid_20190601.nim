
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventGridManagementClient
## version: 2019-06-01
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
  ## List the available operations supported by the Microsoft.EventGrid resource provider.
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
  ## List the available operations supported by the Microsoft.EventGrid resource provider.
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
  ## List the available operations supported by the Microsoft.EventGrid resource provider.
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
  ## List all registered topic types.
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
  ## List all registered topic types.
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
  ## List all registered topic types.
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
  ## Get information about a topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type.
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
  ## Get information about a topic type.
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
  ## Get information about a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type.
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
  ## List event types for a topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type.
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
  ## List event types for a topic type.
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
  ## List event types for a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type.
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
  ## List all the domains under an Azure subscription.
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
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
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
  ## List all the domains under an Azure subscription.
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
  ## List all the domains under an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
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
  ## List all aggregated global event subscriptions under a specific Azure subscription.
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
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  var valid_568225 = query.getOrDefault("$top")
  valid_568225 = validateParameter(valid_568225, JInt, required = false, default = nil)
  if valid_568225 != nil:
    section.add "$top", valid_568225
  var valid_568226 = query.getOrDefault("$filter")
  valid_568226 = validateParameter(valid_568226, JString, required = false,
                                 default = nil)
  if valid_568226 != nil:
    section.add "$filter", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_EventSubscriptionsListGlobalBySubscription_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all aggregated global event subscriptions under a specific Azure subscription.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_EventSubscriptionsListGlobalBySubscription_568220;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalBySubscription
  ## List all aggregated global event subscriptions under a specific Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "subscriptionId", newJString(subscriptionId))
  add(query_568230, "$top", newJInt(Top))
  add(query_568230, "$filter", newJString(Filter))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscription* = Call_EventSubscriptionsListGlobalBySubscription_568220(
    name: "eventSubscriptionsListGlobalBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscription_568221,
    base: "", url: url_EventSubscriptionsListGlobalBySubscription_568222,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscription_568231 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalBySubscription_568233(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalBySubscription_568232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  var valid_568235 = path.getOrDefault("location")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "location", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  var valid_568237 = query.getOrDefault("$top")
  valid_568237 = validateParameter(valid_568237, JInt, required = false, default = nil)
  if valid_568237 != nil:
    section.add "$top", valid_568237
  var valid_568238 = query.getOrDefault("$filter")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$filter", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_EventSubscriptionsListRegionalBySubscription_568231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_EventSubscriptionsListRegionalBySubscription_568231;
          apiVersion: string; subscriptionId: string; location: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalBySubscription
  ## List all event subscriptions from the given location under a specific Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   location: string (required)
  ##           : Name of the location.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(query_568242, "$top", newJInt(Top))
  add(path_568241, "location", newJString(location))
  add(query_568242, "$filter", newJString(Filter))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscription* = Call_EventSubscriptionsListRegionalBySubscription_568231(
    name: "eventSubscriptionsListRegionalBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalBySubscription_568232,
    base: "", url: url_EventSubscriptionsListRegionalBySubscription_568233,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568243 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568245(
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

proc validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568244(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568246 = path.getOrDefault("topicTypeName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "topicTypeName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("location")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "location", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  var valid_568250 = query.getOrDefault("$top")
  valid_568250 = validateParameter(valid_568250, JInt, required = false, default = nil)
  if valid_568250 != nil:
    section.add "$top", valid_568250
  var valid_568251 = query.getOrDefault("$filter")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "$filter", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568243;
          topicTypeName: string; apiVersion: string; subscriptionId: string;
          location: string; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalBySubscriptionForTopicType
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   location: string (required)
  ##           : Name of the location.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(path_568254, "topicTypeName", newJString(topicTypeName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  add(query_568255, "$top", newJInt(Top))
  add(path_568254, "location", newJString(location))
  add(query_568255, "$filter", newJString(Filter))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscriptionForTopicType* = Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568243(
    name: "eventSubscriptionsListRegionalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568244,
    base: "", url: url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568245,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568256 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568258(
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

proc validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568257(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568259 = path.getOrDefault("topicTypeName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "topicTypeName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  var valid_568262 = query.getOrDefault("$top")
  valid_568262 = validateParameter(valid_568262, JInt, required = false, default = nil)
  if valid_568262 != nil:
    section.add "$top", valid_568262
  var valid_568263 = query.getOrDefault("$filter")
  valid_568263 = validateParameter(valid_568263, JString, required = false,
                                 default = nil)
  if valid_568263 != nil:
    section.add "$filter", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568256;
          topicTypeName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalBySubscriptionForTopicType
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(path_568266, "topicTypeName", newJString(topicTypeName))
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  add(query_568267, "$top", newJInt(Top))
  add(query_568267, "$filter", newJString(Filter))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscriptionForTopicType* = Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568256(
    name: "eventSubscriptionsListGlobalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568257,
    base: "", url: url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568258,
    schemes: {Scheme.Https})
type
  Call_TopicsListBySubscription_568268 = ref object of OpenApiRestCall_567651
proc url_TopicsListBySubscription_568270(protocol: Scheme; host: string;
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

proc validate_TopicsListBySubscription_568269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the topics under an Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  var valid_568273 = query.getOrDefault("$top")
  valid_568273 = validateParameter(valid_568273, JInt, required = false, default = nil)
  if valid_568273 != nil:
    section.add "$top", valid_568273
  var valid_568274 = query.getOrDefault("$filter")
  valid_568274 = validateParameter(valid_568274, JString, required = false,
                                 default = nil)
  if valid_568274 != nil:
    section.add "$filter", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_TopicsListBySubscription_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under an Azure subscription.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_TopicsListBySubscription_568268; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## topicsListBySubscription
  ## List all the topics under an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  add(query_568278, "$top", newJInt(Top))
  add(query_568278, "$filter", newJString(Filter))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var topicsListBySubscription* = Call_TopicsListBySubscription_568268(
    name: "topicsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListBySubscription_568269, base: "",
    url: url_TopicsListBySubscription_568270, schemes: {Scheme.Https})
type
  Call_DomainsListByResourceGroup_568279 = ref object of OpenApiRestCall_567651
proc url_DomainsListByResourceGroup_568281(protocol: Scheme; host: string;
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

proc validate_DomainsListByResourceGroup_568280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the domains under a resource group.
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
  var valid_568282 = path.getOrDefault("resourceGroupName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "resourceGroupName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  var valid_568285 = query.getOrDefault("$top")
  valid_568285 = validateParameter(valid_568285, JInt, required = false, default = nil)
  if valid_568285 != nil:
    section.add "$top", valid_568285
  var valid_568286 = query.getOrDefault("$filter")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = nil)
  if valid_568286 != nil:
    section.add "$filter", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568287: Call_DomainsListByResourceGroup_568279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the domains under a resource group.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_DomainsListByResourceGroup_568279;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## domainsListByResourceGroup
  ## List all the domains under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  add(query_568290, "$top", newJInt(Top))
  add(query_568290, "$filter", newJString(Filter))
  result = call_568288.call(path_568289, query_568290, nil, nil, nil)

var domainsListByResourceGroup* = Call_DomainsListByResourceGroup_568279(
    name: "domainsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains",
    validator: validate_DomainsListByResourceGroup_568280, base: "",
    url: url_DomainsListByResourceGroup_568281, schemes: {Scheme.Https})
type
  Call_DomainsCreateOrUpdate_568302 = ref object of OpenApiRestCall_567651
proc url_DomainsCreateOrUpdate_568304(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsCreateOrUpdate_568303(path: JsonNode; query: JsonNode;
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
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  var valid_568307 = path.getOrDefault("domainName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "domainName", valid_568307
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
  ## parameters in `body` object:
  ##   domainInfo: JObject (required)
  ##             : Domain information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_DomainsCreateOrUpdate_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates or updates a new domain with the specified parameters.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_DomainsCreateOrUpdate_568302;
          resourceGroupName: string; domainInfo: JsonNode; apiVersion: string;
          subscriptionId: string; domainName: string): Recallable =
  ## domainsCreateOrUpdate
  ## Asynchronously creates or updates a new domain with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   domainInfo: JObject (required)
  ##             : Domain information.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  var body_568314 = newJObject()
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  if domainInfo != nil:
    body_568314 = domainInfo
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  add(path_568312, "domainName", newJString(domainName))
  result = call_568311.call(path_568312, query_568313, nil, nil, body_568314)

var domainsCreateOrUpdate* = Call_DomainsCreateOrUpdate_568302(
    name: "domainsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsCreateOrUpdate_568303, base: "",
    url: url_DomainsCreateOrUpdate_568304, schemes: {Scheme.Https})
type
  Call_DomainsGet_568291 = ref object of OpenApiRestCall_567651
proc url_DomainsGet_568293(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DomainsGet_568292(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  var valid_568296 = path.getOrDefault("domainName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "domainName", valid_568296
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

proc call*(call_568298: Call_DomainsGet_568291; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a domain.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_DomainsGet_568291; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainName: string): Recallable =
  ## domainsGet
  ## Get properties of a domain.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  add(path_568300, "domainName", newJString(domainName))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var domainsGet* = Call_DomainsGet_568291(name: "domainsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
                                      validator: validate_DomainsGet_568292,
                                      base: "", url: url_DomainsGet_568293,
                                      schemes: {Scheme.Https})
type
  Call_DomainsUpdate_568326 = ref object of OpenApiRestCall_567651
proc url_DomainsUpdate_568328(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsUpdate_568327(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("domainName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "domainName", valid_568331
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
  ## parameters in `body` object:
  ##   domainUpdateParameters: JObject (required)
  ##                         : Domain update information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_DomainsUpdate_568326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a domain with the specified parameters.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_DomainsUpdate_568326; resourceGroupName: string;
          apiVersion: string; domainUpdateParameters: JsonNode;
          subscriptionId: string; domainName: string): Recallable =
  ## domainsUpdate
  ## Asynchronously updates a domain with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   domainUpdateParameters: JObject (required)
  ##                         : Domain update information.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  var body_568338 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  if domainUpdateParameters != nil:
    body_568338 = domainUpdateParameters
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "domainName", newJString(domainName))
  result = call_568335.call(path_568336, query_568337, nil, nil, body_568338)

var domainsUpdate* = Call_DomainsUpdate_568326(name: "domainsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsUpdate_568327, base: "", url: url_DomainsUpdate_568328,
    schemes: {Scheme.Https})
type
  Call_DomainsDelete_568315 = ref object of OpenApiRestCall_567651
proc url_DomainsDelete_568317(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsDelete_568316(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete existing domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("domainName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "domainName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_DomainsDelete_568315; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing domain.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_DomainsDelete_568315; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainName: string): Recallable =
  ## domainsDelete
  ## Delete existing domain.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(path_568324, "resourceGroupName", newJString(resourceGroupName))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  add(path_568324, "domainName", newJString(domainName))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var domainsDelete* = Call_DomainsDelete_568315(name: "domainsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}",
    validator: validate_DomainsDelete_568316, base: "", url: url_DomainsDelete_568317,
    schemes: {Scheme.Https})
type
  Call_DomainsListSharedAccessKeys_568339 = ref object of OpenApiRestCall_567651
proc url_DomainsListSharedAccessKeys_568341(protocol: Scheme; host: string;
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

proc validate_DomainsListSharedAccessKeys_568340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the two keys used to publish to a domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("domainName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "domainName", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_DomainsListSharedAccessKeys_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a domain.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_DomainsListSharedAccessKeys_568339;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainName: string): Recallable =
  ## domainsListSharedAccessKeys
  ## List the two keys used to publish to a domain.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  add(path_568348, "domainName", newJString(domainName))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var domainsListSharedAccessKeys* = Call_DomainsListSharedAccessKeys_568339(
    name: "domainsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/listKeys",
    validator: validate_DomainsListSharedAccessKeys_568340, base: "",
    url: url_DomainsListSharedAccessKeys_568341, schemes: {Scheme.Https})
type
  Call_DomainsRegenerateKey_568350 = ref object of OpenApiRestCall_567651
proc url_DomainsRegenerateKey_568352(protocol: Scheme; host: string; base: string;
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

proc validate_DomainsRegenerateKey_568351(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate a shared access key for a domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  var valid_568355 = path.getOrDefault("domainName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "domainName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_DomainsRegenerateKey_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a domain.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_DomainsRegenerateKey_568350;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainName: string; regenerateKeyRequest: JsonNode): Recallable =
  ## domainsRegenerateKey
  ## Regenerate a shared access key for a domain.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: string (required)
  ##             : Name of the domain.
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  var body_568362 = newJObject()
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "domainName", newJString(domainName))
  if regenerateKeyRequest != nil:
    body_568362 = regenerateKeyRequest
  result = call_568359.call(path_568360, query_568361, nil, nil, body_568362)

var domainsRegenerateKey* = Call_DomainsRegenerateKey_568350(
    name: "domainsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/regenerateKey",
    validator: validate_DomainsRegenerateKey_568351, base: "",
    url: url_DomainsRegenerateKey_568352, schemes: {Scheme.Https})
type
  Call_DomainTopicsListByDomain_568363 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsListByDomain_568365(protocol: Scheme; host: string;
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

proc validate_DomainTopicsListByDomain_568364(path: JsonNode; query: JsonNode;
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
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("domainName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "domainName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  var valid_568370 = query.getOrDefault("$top")
  valid_568370 = validateParameter(valid_568370, JInt, required = false, default = nil)
  if valid_568370 != nil:
    section.add "$top", valid_568370
  var valid_568371 = query.getOrDefault("$filter")
  valid_568371 = validateParameter(valid_568371, JString, required = false,
                                 default = nil)
  if valid_568371 != nil:
    section.add "$filter", valid_568371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_DomainTopicsListByDomain_568363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics in a domain.
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_DomainTopicsListByDomain_568363;
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
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   domainName: string (required)
  ##             : Domain name.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  add(path_568374, "resourceGroupName", newJString(resourceGroupName))
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  add(query_568375, "$top", newJInt(Top))
  add(path_568374, "domainName", newJString(domainName))
  add(query_568375, "$filter", newJString(Filter))
  result = call_568373.call(path_568374, query_568375, nil, nil, nil)

var domainTopicsListByDomain* = Call_DomainTopicsListByDomain_568363(
    name: "domainTopicsListByDomain", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics",
    validator: validate_DomainTopicsListByDomain_568364, base: "",
    url: url_DomainTopicsListByDomain_568365, schemes: {Scheme.Https})
type
  Call_DomainTopicsCreateOrUpdate_568388 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsCreateOrUpdate_568390(protocol: Scheme; host: string;
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

proc validate_DomainTopicsCreateOrUpdate_568389(path: JsonNode; query: JsonNode;
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
  ##                  : Name of the domain topic.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568391 = path.getOrDefault("resourceGroupName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "resourceGroupName", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  var valid_568393 = path.getOrDefault("domainTopicName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "domainTopicName", valid_568393
  var valid_568394 = path.getOrDefault("domainName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "domainName", valid_568394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568395 = query.getOrDefault("api-version")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "api-version", valid_568395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568396: Call_DomainTopicsCreateOrUpdate_568388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates or updates a new domain topic with the specified parameters.
  ## 
  let valid = call_568396.validator(path, query, header, formData, body)
  let scheme = call_568396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568396.url(scheme.get, call_568396.host, call_568396.base,
                         call_568396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568396, url, valid)

proc call*(call_568397: Call_DomainTopicsCreateOrUpdate_568388;
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
  ##                  : Name of the domain topic.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568398 = newJObject()
  var query_568399 = newJObject()
  add(path_568398, "resourceGroupName", newJString(resourceGroupName))
  add(query_568399, "api-version", newJString(apiVersion))
  add(path_568398, "subscriptionId", newJString(subscriptionId))
  add(path_568398, "domainTopicName", newJString(domainTopicName))
  add(path_568398, "domainName", newJString(domainName))
  result = call_568397.call(path_568398, query_568399, nil, nil, nil)

var domainTopicsCreateOrUpdate* = Call_DomainTopicsCreateOrUpdate_568388(
    name: "domainTopicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{domainTopicName}",
    validator: validate_DomainTopicsCreateOrUpdate_568389, base: "",
    url: url_DomainTopicsCreateOrUpdate_568390, schemes: {Scheme.Https})
type
  Call_DomainTopicsGet_568376 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsGet_568378(protocol: Scheme; host: string; base: string;
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

proc validate_DomainTopicsGet_568377(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get properties of a domain topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: JString (required)
  ##                  : Name of the topic.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568379 = path.getOrDefault("resourceGroupName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "resourceGroupName", valid_568379
  var valid_568380 = path.getOrDefault("subscriptionId")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "subscriptionId", valid_568380
  var valid_568381 = path.getOrDefault("domainTopicName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "domainTopicName", valid_568381
  var valid_568382 = path.getOrDefault("domainName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "domainName", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568383 = query.getOrDefault("api-version")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "api-version", valid_568383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_DomainTopicsGet_568376; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a domain topic.
  ## 
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_DomainTopicsGet_568376; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainTopicName: string;
          domainName: string): Recallable =
  ## domainTopicsGet
  ## Get properties of a domain topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: string (required)
  ##                  : Name of the topic.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  add(path_568386, "resourceGroupName", newJString(resourceGroupName))
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "subscriptionId", newJString(subscriptionId))
  add(path_568386, "domainTopicName", newJString(domainTopicName))
  add(path_568386, "domainName", newJString(domainName))
  result = call_568385.call(path_568386, query_568387, nil, nil, nil)

var domainTopicsGet* = Call_DomainTopicsGet_568376(name: "domainTopicsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{domainTopicName}",
    validator: validate_DomainTopicsGet_568377, base: "", url: url_DomainTopicsGet_568378,
    schemes: {Scheme.Https})
type
  Call_DomainTopicsDelete_568400 = ref object of OpenApiRestCall_567651
proc url_DomainTopicsDelete_568402(protocol: Scheme; host: string; base: string;
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

proc validate_DomainTopicsDelete_568401(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete existing domain topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: JString (required)
  ##                  : Name of the domain topic.
  ##   domainName: JString (required)
  ##             : Name of the domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568403 = path.getOrDefault("resourceGroupName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "resourceGroupName", valid_568403
  var valid_568404 = path.getOrDefault("subscriptionId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "subscriptionId", valid_568404
  var valid_568405 = path.getOrDefault("domainTopicName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "domainTopicName", valid_568405
  var valid_568406 = path.getOrDefault("domainName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "domainName", valid_568406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568407 = query.getOrDefault("api-version")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "api-version", valid_568407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568408: Call_DomainTopicsDelete_568400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing domain topic.
  ## 
  let valid = call_568408.validator(path, query, header, formData, body)
  let scheme = call_568408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568408.url(scheme.get, call_568408.host, call_568408.base,
                         call_568408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568408, url, valid)

proc call*(call_568409: Call_DomainTopicsDelete_568400; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainTopicName: string;
          domainName: string): Recallable =
  ## domainTopicsDelete
  ## Delete existing domain topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainTopicName: string (required)
  ##                  : Name of the domain topic.
  ##   domainName: string (required)
  ##             : Name of the domain.
  var path_568410 = newJObject()
  var query_568411 = newJObject()
  add(path_568410, "resourceGroupName", newJString(resourceGroupName))
  add(query_568411, "api-version", newJString(apiVersion))
  add(path_568410, "subscriptionId", newJString(subscriptionId))
  add(path_568410, "domainTopicName", newJString(domainTopicName))
  add(path_568410, "domainName", newJString(domainName))
  result = call_568409.call(path_568410, query_568411, nil, nil, nil)

var domainTopicsDelete* = Call_DomainTopicsDelete_568400(
    name: "domainTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{domainTopicName}",
    validator: validate_DomainTopicsDelete_568401, base: "",
    url: url_DomainTopicsDelete_568402, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByDomainTopic_568412 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListByDomainTopic_568414(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsListByDomainTopic_568413(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all event subscriptions that have been created for a specific domain topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the domain topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainName: JString (required)
  ##             : Name of the top level domain.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568415 = path.getOrDefault("resourceGroupName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceGroupName", valid_568415
  var valid_568416 = path.getOrDefault("topicName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "topicName", valid_568416
  var valid_568417 = path.getOrDefault("subscriptionId")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "subscriptionId", valid_568417
  var valid_568418 = path.getOrDefault("domainName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "domainName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
  var valid_568420 = query.getOrDefault("$top")
  valid_568420 = validateParameter(valid_568420, JInt, required = false, default = nil)
  if valid_568420 != nil:
    section.add "$top", valid_568420
  var valid_568421 = query.getOrDefault("$filter")
  valid_568421 = validateParameter(valid_568421, JString, required = false,
                                 default = nil)
  if valid_568421 != nil:
    section.add "$filter", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_EventSubscriptionsListByDomainTopic_568412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific domain topic.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_EventSubscriptionsListByDomainTopic_568412;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; domainName: string; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListByDomainTopic
  ## List all event subscriptions that have been created for a specific domain topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the domain topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   domainName: string (required)
  ##             : Name of the top level domain.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(path_568424, "resourceGroupName", newJString(resourceGroupName))
  add(query_568425, "api-version", newJString(apiVersion))
  add(path_568424, "topicName", newJString(topicName))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  add(query_568425, "$top", newJInt(Top))
  add(path_568424, "domainName", newJString(domainName))
  add(query_568425, "$filter", newJString(Filter))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var eventSubscriptionsListByDomainTopic* = Call_EventSubscriptionsListByDomainTopic_568412(
    name: "eventSubscriptionsListByDomainTopic", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/domains/{domainName}/topics/{topicName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByDomainTopic_568413, base: "",
    url: url_EventSubscriptionsListByDomainTopic_568414, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroup_568426 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalByResourceGroup_568428(protocol: Scheme;
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

proc validate_EventSubscriptionsListGlobalByResourceGroup_568427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all global event subscriptions under a specific Azure subscription and resource group.
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
  var valid_568429 = path.getOrDefault("resourceGroupName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "resourceGroupName", valid_568429
  var valid_568430 = path.getOrDefault("subscriptionId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "subscriptionId", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
  var valid_568432 = query.getOrDefault("$top")
  valid_568432 = validateParameter(valid_568432, JInt, required = false, default = nil)
  if valid_568432 != nil:
    section.add "$top", valid_568432
  var valid_568433 = query.getOrDefault("$filter")
  valid_568433 = validateParameter(valid_568433, JString, required = false,
                                 default = nil)
  if valid_568433 != nil:
    section.add "$filter", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_EventSubscriptionsListGlobalByResourceGroup_568426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a specific Azure subscription and resource group.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_EventSubscriptionsListGlobalByResourceGroup_568426;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroup
  ## List all global event subscriptions under a specific Azure subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(path_568436, "resourceGroupName", newJString(resourceGroupName))
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "subscriptionId", newJString(subscriptionId))
  add(query_568437, "$top", newJInt(Top))
  add(query_568437, "$filter", newJString(Filter))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroup* = Call_EventSubscriptionsListGlobalByResourceGroup_568426(
    name: "eventSubscriptionsListGlobalByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalByResourceGroup_568427,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroup_568428,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroup_568438 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalByResourceGroup_568440(protocol: Scheme;
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

proc validate_EventSubscriptionsListRegionalByResourceGroup_568439(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568441 = path.getOrDefault("resourceGroupName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "resourceGroupName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  var valid_568443 = path.getOrDefault("location")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "location", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  var valid_568445 = query.getOrDefault("$top")
  valid_568445 = validateParameter(valid_568445, JInt, required = false, default = nil)
  if valid_568445 != nil:
    section.add "$top", valid_568445
  var valid_568446 = query.getOrDefault("$filter")
  valid_568446 = validateParameter(valid_568446, JString, required = false,
                                 default = nil)
  if valid_568446 != nil:
    section.add "$filter", valid_568446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_EventSubscriptionsListRegionalByResourceGroup_568438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_EventSubscriptionsListRegionalByResourceGroup_568438;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          location: string; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalByResourceGroup
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   location: string (required)
  ##           : Name of the location.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  add(query_568450, "$top", newJInt(Top))
  add(path_568449, "location", newJString(location))
  add(query_568450, "$filter", newJString(Filter))
  result = call_568448.call(path_568449, query_568450, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroup* = Call_EventSubscriptionsListRegionalByResourceGroup_568438(
    name: "eventSubscriptionsListRegionalByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalByResourceGroup_568439,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroup_568440,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568451 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568453(
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

proc validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568452(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568454 = path.getOrDefault("topicTypeName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "topicTypeName", valid_568454
  var valid_568455 = path.getOrDefault("resourceGroupName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "resourceGroupName", valid_568455
  var valid_568456 = path.getOrDefault("subscriptionId")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "subscriptionId", valid_568456
  var valid_568457 = path.getOrDefault("location")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "location", valid_568457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568458 = query.getOrDefault("api-version")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "api-version", valid_568458
  var valid_568459 = query.getOrDefault("$top")
  valid_568459 = validateParameter(valid_568459, JInt, required = false, default = nil)
  if valid_568459 != nil:
    section.add "$top", valid_568459
  var valid_568460 = query.getOrDefault("$filter")
  valid_568460 = validateParameter(valid_568460, JString, required = false,
                                 default = nil)
  if valid_568460 != nil:
    section.add "$filter", valid_568460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568451;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type.
  ## 
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568451;
          topicTypeName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; location: string; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListRegionalByResourceGroupForTopicType
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   location: string (required)
  ##           : Name of the location.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  add(path_568463, "topicTypeName", newJString(topicTypeName))
  add(path_568463, "resourceGroupName", newJString(resourceGroupName))
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "subscriptionId", newJString(subscriptionId))
  add(query_568464, "$top", newJInt(Top))
  add(path_568463, "location", newJString(location))
  add(query_568464, "$filter", newJString(Filter))
  result = call_568462.call(path_568463, query_568464, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroupForTopicType* = Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568451(
    name: "eventSubscriptionsListRegionalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568452,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568453,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568465 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568467(
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

proc validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568466(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568468 = path.getOrDefault("topicTypeName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "topicTypeName", valid_568468
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568471 = query.getOrDefault("api-version")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "api-version", valid_568471
  var valid_568472 = query.getOrDefault("$top")
  valid_568472 = validateParameter(valid_568472, JInt, required = false, default = nil)
  if valid_568472 != nil:
    section.add "$top", valid_568472
  var valid_568473 = query.getOrDefault("$filter")
  valid_568473 = validateParameter(valid_568473, JString, required = false,
                                 default = nil)
  if valid_568473 != nil:
    section.add "$filter", valid_568473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568465;
          topicTypeName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroupForTopicType
  ## List all global event subscriptions under a resource group for a specific topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  add(path_568476, "topicTypeName", newJString(topicTypeName))
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  add(query_568477, "$top", newJInt(Top))
  add(query_568477, "$filter", newJString(Filter))
  result = call_568475.call(path_568476, query_568477, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroupForTopicType* = Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568465(
    name: "eventSubscriptionsListGlobalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568466,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568467,
    schemes: {Scheme.Https})
type
  Call_TopicsListByResourceGroup_568478 = ref object of OpenApiRestCall_567651
proc url_TopicsListByResourceGroup_568480(protocol: Scheme; host: string;
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

proc validate_TopicsListByResourceGroup_568479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the topics under a resource group.
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
  var valid_568481 = path.getOrDefault("resourceGroupName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "resourceGroupName", valid_568481
  var valid_568482 = path.getOrDefault("subscriptionId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "subscriptionId", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  var valid_568484 = query.getOrDefault("$top")
  valid_568484 = validateParameter(valid_568484, JInt, required = false, default = nil)
  if valid_568484 != nil:
    section.add "$top", valid_568484
  var valid_568485 = query.getOrDefault("$filter")
  valid_568485 = validateParameter(valid_568485, JString, required = false,
                                 default = nil)
  if valid_568485 != nil:
    section.add "$filter", valid_568485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_TopicsListByResourceGroup_568478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under a resource group.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_TopicsListByResourceGroup_568478;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## topicsListByResourceGroup
  ## List all the topics under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  add(query_568489, "$top", newJInt(Top))
  add(query_568489, "$filter", newJString(Filter))
  result = call_568487.call(path_568488, query_568489, nil, nil, nil)

var topicsListByResourceGroup* = Call_TopicsListByResourceGroup_568478(
    name: "topicsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListByResourceGroup_568479, base: "",
    url: url_TopicsListByResourceGroup_568480, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568501 = ref object of OpenApiRestCall_567651
proc url_TopicsCreateOrUpdate_568503(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsCreateOrUpdate_568502(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("topicName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "topicName", valid_568505
  var valid_568506 = path.getOrDefault("subscriptionId")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "subscriptionId", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   topicInfo: JObject (required)
  ##            : Topic information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568509: Call_TopicsCreateOrUpdate_568501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  let valid = call_568509.validator(path, query, header, formData, body)
  let scheme = call_568509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568509.url(scheme.get, call_568509.host, call_568509.base,
                         call_568509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568509, url, valid)

proc call*(call_568510: Call_TopicsCreateOrUpdate_568501;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; topicInfo: JsonNode): Recallable =
  ## topicsCreateOrUpdate
  ## Asynchronously creates a new topic with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   topicInfo: JObject (required)
  ##            : Topic information.
  var path_568511 = newJObject()
  var query_568512 = newJObject()
  var body_568513 = newJObject()
  add(path_568511, "resourceGroupName", newJString(resourceGroupName))
  add(query_568512, "api-version", newJString(apiVersion))
  add(path_568511, "topicName", newJString(topicName))
  add(path_568511, "subscriptionId", newJString(subscriptionId))
  if topicInfo != nil:
    body_568513 = topicInfo
  result = call_568510.call(path_568511, query_568512, nil, nil, body_568513)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568501(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568502, base: "",
    url: url_TopicsCreateOrUpdate_568503, schemes: {Scheme.Https})
type
  Call_TopicsGet_568490 = ref object of OpenApiRestCall_567651
proc url_TopicsGet_568492(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TopicsGet_568491(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("topicName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "topicName", valid_568494
  var valid_568495 = path.getOrDefault("subscriptionId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "subscriptionId", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568497: Call_TopicsGet_568490; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a topic.
  ## 
  let valid = call_568497.validator(path, query, header, formData, body)
  let scheme = call_568497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568497.url(scheme.get, call_568497.host, call_568497.base,
                         call_568497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568497, url, valid)

proc call*(call_568498: Call_TopicsGet_568490; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string): Recallable =
  ## topicsGet
  ## Get properties of a topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568499 = newJObject()
  var query_568500 = newJObject()
  add(path_568499, "resourceGroupName", newJString(resourceGroupName))
  add(query_568500, "api-version", newJString(apiVersion))
  add(path_568499, "topicName", newJString(topicName))
  add(path_568499, "subscriptionId", newJString(subscriptionId))
  result = call_568498.call(path_568499, query_568500, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568490(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
                                    validator: validate_TopicsGet_568491,
                                    base: "", url: url_TopicsGet_568492,
                                    schemes: {Scheme.Https})
type
  Call_TopicsUpdate_568525 = ref object of OpenApiRestCall_567651
proc url_TopicsUpdate_568527(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsUpdate_568526(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously updates a topic with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("topicName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "topicName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   topicUpdateParameters: JObject (required)
  ##                        : Topic update information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568533: Call_TopicsUpdate_568525; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates a topic with the specified parameters.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_TopicsUpdate_568525; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string;
          topicUpdateParameters: JsonNode): Recallable =
  ## topicsUpdate
  ## Asynchronously updates a topic with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   topicUpdateParameters: JObject (required)
  ##                        : Topic update information.
  var path_568535 = newJObject()
  var query_568536 = newJObject()
  var body_568537 = newJObject()
  add(path_568535, "resourceGroupName", newJString(resourceGroupName))
  add(query_568536, "api-version", newJString(apiVersion))
  add(path_568535, "topicName", newJString(topicName))
  add(path_568535, "subscriptionId", newJString(subscriptionId))
  if topicUpdateParameters != nil:
    body_568537 = topicUpdateParameters
  result = call_568534.call(path_568535, query_568536, nil, nil, body_568537)

var topicsUpdate* = Call_TopicsUpdate_568525(name: "topicsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsUpdate_568526, base: "", url: url_TopicsUpdate_568527,
    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568514 = ref object of OpenApiRestCall_567651
proc url_TopicsDelete_568516(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsDelete_568515(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete existing topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568517 = path.getOrDefault("resourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("topicName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "topicName", valid_568518
  var valid_568519 = path.getOrDefault("subscriptionId")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "subscriptionId", valid_568519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "api-version", valid_568520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568521: Call_TopicsDelete_568514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing topic.
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_TopicsDelete_568514; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string): Recallable =
  ## topicsDelete
  ## Delete existing topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "topicName", newJString(topicName))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  result = call_568522.call(path_568523, query_568524, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568514(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsDelete_568515, base: "", url: url_TopicsDelete_568516,
    schemes: {Scheme.Https})
type
  Call_TopicsListSharedAccessKeys_568538 = ref object of OpenApiRestCall_567651
proc url_TopicsListSharedAccessKeys_568540(protocol: Scheme; host: string;
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

proc validate_TopicsListSharedAccessKeys_568539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the two keys used to publish to a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568541 = path.getOrDefault("resourceGroupName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "resourceGroupName", valid_568541
  var valid_568542 = path.getOrDefault("topicName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "topicName", valid_568542
  var valid_568543 = path.getOrDefault("subscriptionId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "subscriptionId", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568545: Call_TopicsListSharedAccessKeys_568538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a topic.
  ## 
  let valid = call_568545.validator(path, query, header, formData, body)
  let scheme = call_568545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568545.url(scheme.get, call_568545.host, call_568545.base,
                         call_568545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568545, url, valid)

proc call*(call_568546: Call_TopicsListSharedAccessKeys_568538;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## topicsListSharedAccessKeys
  ## List the two keys used to publish to a topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568547 = newJObject()
  var query_568548 = newJObject()
  add(path_568547, "resourceGroupName", newJString(resourceGroupName))
  add(query_568548, "api-version", newJString(apiVersion))
  add(path_568547, "topicName", newJString(topicName))
  add(path_568547, "subscriptionId", newJString(subscriptionId))
  result = call_568546.call(path_568547, query_568548, nil, nil, nil)

var topicsListSharedAccessKeys* = Call_TopicsListSharedAccessKeys_568538(
    name: "topicsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/listKeys",
    validator: validate_TopicsListSharedAccessKeys_568539, base: "",
    url: url_TopicsListSharedAccessKeys_568540, schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKey_568549 = ref object of OpenApiRestCall_567651
proc url_TopicsRegenerateKey_568551(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsRegenerateKey_568550(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Regenerate a shared access key for a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568552 = path.getOrDefault("resourceGroupName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "resourceGroupName", valid_568552
  var valid_568553 = path.getOrDefault("topicName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "topicName", valid_568553
  var valid_568554 = path.getOrDefault("subscriptionId")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "subscriptionId", valid_568554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568557: Call_TopicsRegenerateKey_568549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a topic.
  ## 
  let valid = call_568557.validator(path, query, header, formData, body)
  let scheme = call_568557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568557.url(scheme.get, call_568557.host, call_568557.base,
                         call_568557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568557, url, valid)

proc call*(call_568558: Call_TopicsRegenerateKey_568549; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string;
          regenerateKeyRequest: JsonNode): Recallable =
  ## topicsRegenerateKey
  ## Regenerate a shared access key for a topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key.
  var path_568559 = newJObject()
  var query_568560 = newJObject()
  var body_568561 = newJObject()
  add(path_568559, "resourceGroupName", newJString(resourceGroupName))
  add(query_568560, "api-version", newJString(apiVersion))
  add(path_568559, "topicName", newJString(topicName))
  add(path_568559, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyRequest != nil:
    body_568561 = regenerateKeyRequest
  result = call_568558.call(path_568559, query_568560, nil, nil, body_568561)

var topicsRegenerateKey* = Call_TopicsRegenerateKey_568549(
    name: "topicsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/regenerateKey",
    validator: validate_TopicsRegenerateKey_568550, base: "",
    url: url_TopicsRegenerateKey_568551, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByResource_568562 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsListByResource_568564(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsListByResource_568563(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all event subscriptions that have been created for a specific topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerNamespace: JString (required)
  ##                    : Namespace of the provider of the topic.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceTypeName: JString (required)
  ##                   : Name of the resource type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerNamespace` field"
  var valid_568565 = path.getOrDefault("providerNamespace")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "providerNamespace", valid_568565
  var valid_568566 = path.getOrDefault("resourceGroupName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "resourceGroupName", valid_568566
  var valid_568567 = path.getOrDefault("subscriptionId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "subscriptionId", valid_568567
  var valid_568568 = path.getOrDefault("resourceName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "resourceName", valid_568568
  var valid_568569 = path.getOrDefault("resourceTypeName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "resourceTypeName", valid_568569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   $filter: JString
  ##          : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568570 = query.getOrDefault("api-version")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "api-version", valid_568570
  var valid_568571 = query.getOrDefault("$top")
  valid_568571 = validateParameter(valid_568571, JInt, required = false, default = nil)
  if valid_568571 != nil:
    section.add "$top", valid_568571
  var valid_568572 = query.getOrDefault("$filter")
  valid_568572 = validateParameter(valid_568572, JString, required = false,
                                 default = nil)
  if valid_568572 != nil:
    section.add "$filter", valid_568572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568573: Call_EventSubscriptionsListByResource_568562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific topic.
  ## 
  let valid = call_568573.validator(path, query, header, formData, body)
  let scheme = call_568573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568573.url(scheme.get, call_568573.host, call_568573.base,
                         call_568573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568573, url, valid)

proc call*(call_568574: Call_EventSubscriptionsListByResource_568562;
          providerNamespace: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceTypeName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## eventSubscriptionsListByResource
  ## List all event subscriptions that have been created for a specific topic.
  ##   providerNamespace: string (required)
  ##                    : Namespace of the provider of the topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : The number of results to return per page for the list operation. Valid range for top parameter is 1 to 100. If not specified, the default number of results to be returned is 20 items per page.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceTypeName: string (required)
  ##                   : Name of the resource type.
  ##   Filter: string
  ##         : The query used to filter the search results using OData syntax. Filtering is permitted on the 'name' property only and with limited number of OData operations. These operations are: the 'contains' function as well as the following logical operations: not, and, or, eq (for equal), and ne (for not equal). No arithmetic operations are supported. The following is a valid filter example: $filter=contains(namE, 'PATTERN') and name ne 'PATTERN-1'. The following is not a valid filter example: $filter=location eq 'westus'.
  var path_568575 = newJObject()
  var query_568576 = newJObject()
  add(path_568575, "providerNamespace", newJString(providerNamespace))
  add(path_568575, "resourceGroupName", newJString(resourceGroupName))
  add(query_568576, "api-version", newJString(apiVersion))
  add(path_568575, "subscriptionId", newJString(subscriptionId))
  add(query_568576, "$top", newJInt(Top))
  add(path_568575, "resourceName", newJString(resourceName))
  add(path_568575, "resourceTypeName", newJString(resourceTypeName))
  add(query_568576, "$filter", newJString(Filter))
  result = call_568574.call(path_568575, query_568576, nil, nil, nil)

var eventSubscriptionsListByResource* = Call_EventSubscriptionsListByResource_568562(
    name: "eventSubscriptionsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByResource_568563, base: "",
    url: url_EventSubscriptionsListByResource_568564, schemes: {Scheme.Https})
type
  Call_TopicsListEventTypes_568577 = ref object of OpenApiRestCall_567651
proc url_TopicsListEventTypes_568579(protocol: Scheme; host: string; base: string;
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

proc validate_TopicsListEventTypes_568578(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List event types for a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerNamespace: JString (required)
  ##                    : Namespace of the provider of the topic.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Name of the topic.
  ##   resourceTypeName: JString (required)
  ##                   : Name of the topic type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerNamespace` field"
  var valid_568580 = path.getOrDefault("providerNamespace")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "providerNamespace", valid_568580
  var valid_568581 = path.getOrDefault("resourceGroupName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "resourceGroupName", valid_568581
  var valid_568582 = path.getOrDefault("subscriptionId")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "subscriptionId", valid_568582
  var valid_568583 = path.getOrDefault("resourceName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "resourceName", valid_568583
  var valid_568584 = path.getOrDefault("resourceTypeName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceTypeName", valid_568584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568585 = query.getOrDefault("api-version")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "api-version", valid_568585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568586: Call_TopicsListEventTypes_568577; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic.
  ## 
  let valid = call_568586.validator(path, query, header, formData, body)
  let scheme = call_568586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568586.url(scheme.get, call_568586.host, call_568586.base,
                         call_568586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568586, url, valid)

proc call*(call_568587: Call_TopicsListEventTypes_568577;
          providerNamespace: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceTypeName: string): Recallable =
  ## topicsListEventTypes
  ## List event types for a topic.
  ##   providerNamespace: string (required)
  ##                    : Namespace of the provider of the topic.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Name of the topic.
  ##   resourceTypeName: string (required)
  ##                   : Name of the topic type.
  var path_568588 = newJObject()
  var query_568589 = newJObject()
  add(path_568588, "providerNamespace", newJString(providerNamespace))
  add(path_568588, "resourceGroupName", newJString(resourceGroupName))
  add(query_568589, "api-version", newJString(apiVersion))
  add(path_568588, "subscriptionId", newJString(subscriptionId))
  add(path_568588, "resourceName", newJString(resourceName))
  add(path_568588, "resourceTypeName", newJString(resourceTypeName))
  result = call_568587.call(path_568588, query_568589, nil, nil, nil)

var topicsListEventTypes* = Call_TopicsListEventTypes_568577(
    name: "topicsListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventTypes",
    validator: validate_TopicsListEventTypes_568578, base: "",
    url: url_TopicsListEventTypes_568579, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsCreateOrUpdate_568600 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsCreateOrUpdate_568602(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsCreateOrUpdate_568601(path: JsonNode;
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
  ## parameters in `body` object:
  ##   eventSubscriptionInfo: JObject (required)
  ##                        : Event subscription properties containing the destination and filter information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568607: Call_EventSubscriptionsCreateOrUpdate_568600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ## 
  let valid = call_568607.validator(path, query, header, formData, body)
  let scheme = call_568607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568607.url(scheme.get, call_568607.host, call_568607.base,
                         call_568607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568607, url, valid)

proc call*(call_568608: Call_EventSubscriptionsCreateOrUpdate_568600;
          eventSubscriptionInfo: JsonNode; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsCreateOrUpdate
  ## Asynchronously creates a new event subscription or updates an existing event subscription based on the specified scope.
  ##   eventSubscriptionInfo: JObject (required)
  ##                        : Event subscription properties containing the destination and filter information.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription. Event subscription names must be between 3 and 64 characters in length and should use alphanumeric letters only.
  ##   scope: string (required)
  ##        : The identifier of the resource to which the event subscription needs to be created or updated. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568609 = newJObject()
  var query_568610 = newJObject()
  var body_568611 = newJObject()
  if eventSubscriptionInfo != nil:
    body_568611 = eventSubscriptionInfo
  add(query_568610, "api-version", newJString(apiVersion))
  add(path_568609, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568609, "scope", newJString(scope))
  result = call_568608.call(path_568609, query_568610, nil, nil, body_568611)

var eventSubscriptionsCreateOrUpdate* = Call_EventSubscriptionsCreateOrUpdate_568600(
    name: "eventSubscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsCreateOrUpdate_568601, base: "",
    url: url_EventSubscriptionsCreateOrUpdate_568602, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGet_568590 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsGet_568592(protocol: Scheme; host: string; base: string;
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

proc validate_EventSubscriptionsGet_568591(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of an event subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription.
  ##   scope: JString (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568593 = path.getOrDefault("eventSubscriptionName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "eventSubscriptionName", valid_568593
  var valid_568594 = path.getOrDefault("scope")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "scope", valid_568594
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

proc call*(call_568596: Call_EventSubscriptionsGet_568590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of an event subscription.
  ## 
  let valid = call_568596.validator(path, query, header, formData, body)
  let scheme = call_568596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568596.url(scheme.get, call_568596.host, call_568596.base,
                         call_568596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568596, url, valid)

proc call*(call_568597: Call_EventSubscriptionsGet_568590; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsGet
  ## Get properties of an event subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription.
  ##   scope: string (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568598 = newJObject()
  var query_568599 = newJObject()
  add(query_568599, "api-version", newJString(apiVersion))
  add(path_568598, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568598, "scope", newJString(scope))
  result = call_568597.call(path_568598, query_568599, nil, nil, nil)

var eventSubscriptionsGet* = Call_EventSubscriptionsGet_568590(
    name: "eventSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsGet_568591, base: "",
    url: url_EventSubscriptionsGet_568592, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsUpdate_568622 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsUpdate_568624(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsUpdate_568623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously updates an existing event subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription to be updated.
  ##   scope: JString (required)
  ##        : The scope of existing event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
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
  ## parameters in `body` object:
  ##   eventSubscriptionUpdateParameters: JObject (required)
  ##                                    : Updated event subscription information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568629: Call_EventSubscriptionsUpdate_568622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates an existing event subscription.
  ## 
  let valid = call_568629.validator(path, query, header, formData, body)
  let scheme = call_568629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568629.url(scheme.get, call_568629.host, call_568629.base,
                         call_568629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568629, url, valid)

proc call*(call_568630: Call_EventSubscriptionsUpdate_568622; apiVersion: string;
          eventSubscriptionName: string; scope: string;
          eventSubscriptionUpdateParameters: JsonNode): Recallable =
  ## eventSubscriptionsUpdate
  ## Asynchronously updates an existing event subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription to be updated.
  ##   scope: string (required)
  ##        : The scope of existing event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  ##   eventSubscriptionUpdateParameters: JObject (required)
  ##                                    : Updated event subscription information.
  var path_568631 = newJObject()
  var query_568632 = newJObject()
  var body_568633 = newJObject()
  add(query_568632, "api-version", newJString(apiVersion))
  add(path_568631, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568631, "scope", newJString(scope))
  if eventSubscriptionUpdateParameters != nil:
    body_568633 = eventSubscriptionUpdateParameters
  result = call_568630.call(path_568631, query_568632, nil, nil, body_568633)

var eventSubscriptionsUpdate* = Call_EventSubscriptionsUpdate_568622(
    name: "eventSubscriptionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsUpdate_568623, base: "",
    url: url_EventSubscriptionsUpdate_568624, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsDelete_568612 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsDelete_568614(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsDelete_568613(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing event subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription.
  ##   scope: JString (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568615 = path.getOrDefault("eventSubscriptionName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "eventSubscriptionName", valid_568615
  var valid_568616 = path.getOrDefault("scope")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "scope", valid_568616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568617 = query.getOrDefault("api-version")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "api-version", valid_568617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568618: Call_EventSubscriptionsDelete_568612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing event subscription.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_EventSubscriptionsDelete_568612; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsDelete
  ## Delete an existing event subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription.
  ##   scope: string (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568620 = newJObject()
  var query_568621 = newJObject()
  add(query_568621, "api-version", newJString(apiVersion))
  add(path_568620, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568620, "scope", newJString(scope))
  result = call_568619.call(path_568620, query_568621, nil, nil, nil)

var eventSubscriptionsDelete* = Call_EventSubscriptionsDelete_568612(
    name: "eventSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsDelete_568613, base: "",
    url: url_EventSubscriptionsDelete_568614, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGetFullUrl_568634 = ref object of OpenApiRestCall_567651
proc url_EventSubscriptionsGetFullUrl_568636(protocol: Scheme; host: string;
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

proc validate_EventSubscriptionsGetFullUrl_568635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the full endpoint URL for an event subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription.
  ##   scope: JString (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568637 = path.getOrDefault("eventSubscriptionName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "eventSubscriptionName", valid_568637
  var valid_568638 = path.getOrDefault("scope")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "scope", valid_568638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568639 = query.getOrDefault("api-version")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "api-version", valid_568639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568640: Call_EventSubscriptionsGetFullUrl_568634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the full endpoint URL for an event subscription.
  ## 
  let valid = call_568640.validator(path, query, header, formData, body)
  let scheme = call_568640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568640.url(scheme.get, call_568640.host, call_568640.base,
                         call_568640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568640, url, valid)

proc call*(call_568641: Call_EventSubscriptionsGetFullUrl_568634;
          apiVersion: string; eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsGetFullUrl
  ## Get the full endpoint URL for an event subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription.
  ##   scope: string (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568642 = newJObject()
  var query_568643 = newJObject()
  add(query_568643, "api-version", newJString(apiVersion))
  add(path_568642, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568642, "scope", newJString(scope))
  result = call_568641.call(path_568642, query_568643, nil, nil, nil)

var eventSubscriptionsGetFullUrl* = Call_EventSubscriptionsGetFullUrl_568634(
    name: "eventSubscriptionsGetFullUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}/getFullUrl",
    validator: validate_EventSubscriptionsGetFullUrl_568635, base: "",
    url: url_EventSubscriptionsGetFullUrl_568636, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
