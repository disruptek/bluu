
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CommerceManagementClient
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Commerce Management Client.
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

  OpenApiRestCall_582441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Commerce"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_582663 = ref object of OpenApiRestCall_582441
proc url_OperationsList_582665(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_582664(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the list of supported REST operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582837 = query.getOrDefault("api-version")
  valid_582837 = validateParameter(valid_582837, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_582837 != nil:
    section.add "api-version", valid_582837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582860: Call_OperationsList_582663; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of supported REST operations.
  ## 
  let valid = call_582860.validator(path, query, header, formData, body)
  let scheme = call_582860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582860.url(scheme.get, call_582860.host, call_582860.base,
                         call_582860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582860, url, valid)

proc call*(call_582931: Call_OperationsList_582663;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## operationsList
  ## Returns the list of supported REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_582932 = newJObject()
  add(query_582932, "api-version", newJString(apiVersion))
  result = call_582931.call(nil, query_582932, nil, nil, nil)

var operationsList* = Call_OperationsList_582663(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Commerce.Admin/operations",
    validator: validate_OperationsList_582664, base: "", url: url_OperationsList_582665,
    schemes: {Scheme.Https})
type
  Call_SubscriberUsageAggregatesList_582972 = ref object of OpenApiRestCall_582441
proc url_SubscriberUsageAggregatesList_582974(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Commerce.Admin/subscriberUsageAggregates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriberUsageAggregatesList_582973(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_582989 = path.getOrDefault("subscriptionId")
  valid_582989 = validateParameter(valid_582989, JString, required = true,
                                 default = nil)
  if valid_582989 != nil:
    section.add "subscriptionId", valid_582989
  result.add "path", section
  ## parameters in `query` object:
  ##   subscriberId: JString
  ##               : The tenant subscription identifier.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   reportedStartTime: JString (required)
  ##                    : The reported start time (inclusive).
  ##   reportedEndTime: JString (required)
  ##                  : The reported end time (exclusive).
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   aggregationGranularity: JString
  ##                         : The aggregation granularity.
  section = newJObject()
  var valid_582990 = query.getOrDefault("subscriberId")
  valid_582990 = validateParameter(valid_582990, JString, required = false,
                                 default = nil)
  if valid_582990 != nil:
    section.add "subscriberId", valid_582990
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582991 = query.getOrDefault("api-version")
  valid_582991 = validateParameter(valid_582991, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_582991 != nil:
    section.add "api-version", valid_582991
  var valid_582992 = query.getOrDefault("reportedStartTime")
  valid_582992 = validateParameter(valid_582992, JString, required = true,
                                 default = nil)
  if valid_582992 != nil:
    section.add "reportedStartTime", valid_582992
  var valid_582993 = query.getOrDefault("reportedEndTime")
  valid_582993 = validateParameter(valid_582993, JString, required = true,
                                 default = nil)
  if valid_582993 != nil:
    section.add "reportedEndTime", valid_582993
  var valid_582994 = query.getOrDefault("continuationToken")
  valid_582994 = validateParameter(valid_582994, JString, required = false,
                                 default = nil)
  if valid_582994 != nil:
    section.add "continuationToken", valid_582994
  var valid_582995 = query.getOrDefault("aggregationGranularity")
  valid_582995 = validateParameter(valid_582995, JString, required = false,
                                 default = nil)
  if valid_582995 != nil:
    section.add "aggregationGranularity", valid_582995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582996: Call_SubscriberUsageAggregatesList_582972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ## 
  let valid = call_582996.validator(path, query, header, formData, body)
  let scheme = call_582996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582996.url(scheme.get, call_582996.host, call_582996.base,
                         call_582996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582996, url, valid)

proc call*(call_582997: Call_SubscriberUsageAggregatesList_582972;
          subscriptionId: string; reportedStartTime: string;
          reportedEndTime: string; subscriberId: string = "";
          apiVersion: string = "2015-06-01-preview"; continuationToken: string = "";
          aggregationGranularity: string = ""): Recallable =
  ## subscriberUsageAggregatesList
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ##   subscriberId: string
  ##               : The tenant subscription identifier.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   reportedStartTime: string (required)
  ##                    : The reported start time (inclusive).
  ##   reportedEndTime: string (required)
  ##                  : The reported end time (exclusive).
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   aggregationGranularity: string
  ##                         : The aggregation granularity.
  var path_582998 = newJObject()
  var query_582999 = newJObject()
  add(query_582999, "subscriberId", newJString(subscriberId))
  add(query_582999, "api-version", newJString(apiVersion))
  add(path_582998, "subscriptionId", newJString(subscriptionId))
  add(query_582999, "reportedStartTime", newJString(reportedStartTime))
  add(query_582999, "reportedEndTime", newJString(reportedEndTime))
  add(query_582999, "continuationToken", newJString(continuationToken))
  add(query_582999, "aggregationGranularity", newJString(aggregationGranularity))
  result = call_582997.call(path_582998, query_582999, nil, nil, nil)

var subscriberUsageAggregatesList* = Call_SubscriberUsageAggregatesList_582972(
    name: "subscriberUsageAggregatesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce.Admin/subscriberUsageAggregates",
    validator: validate_SubscriberUsageAggregatesList_582973, base: "",
    url: url_SubscriberUsageAggregatesList_582974, schemes: {Scheme.Https})
type
  Call_UpdateEncryption_583000 = ref object of OpenApiRestCall_582441
proc url_UpdateEncryption_583002(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Commerce.Admin/updateEncryption")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateEncryption_583001(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Update the encryption.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_583003 = path.getOrDefault("subscriptionId")
  valid_583003 = validateParameter(valid_583003, JString, required = true,
                                 default = nil)
  if valid_583003 != nil:
    section.add "subscriptionId", valid_583003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583004 = query.getOrDefault("api-version")
  valid_583004 = validateParameter(valid_583004, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_583004 != nil:
    section.add "api-version", valid_583004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583005: Call_UpdateEncryption_583000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the encryption.
  ## 
  let valid = call_583005.validator(path, query, header, formData, body)
  let scheme = call_583005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583005.url(scheme.get, call_583005.host, call_583005.base,
                         call_583005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583005, url, valid)

proc call*(call_583006: Call_UpdateEncryption_583000; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## updateEncryption
  ## Update the encryption.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_583007 = newJObject()
  var query_583008 = newJObject()
  add(query_583008, "api-version", newJString(apiVersion))
  add(path_583007, "subscriptionId", newJString(subscriptionId))
  result = call_583006.call(path_583007, query_583008, nil, nil, nil)

var updateEncryption* = Call_UpdateEncryption_583000(name: "updateEncryption",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce.Admin/updateEncryption",
    validator: validate_UpdateEncryption_583001, base: "",
    url: url_UpdateEncryption_583002, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
