
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: UsageManagementClient
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "commerce"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RateCardGet_567880 = ref object of OpenApiRestCall_567658
proc url_RateCardGet_567882(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Commerce/RateCard")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RateCardGet_567881(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables you to query for the resource/meter metadata and related prices used in a given subscription by Offer ID, Currency, Locale and Region. The metadata associated with the billing meters, including but not limited to service names, types, resources, units of measure, and regions, is subject to change at any time and without notice. If you intend to use this billing data in an automated fashion, please use the billing meter GUID to uniquely identify each billable item. If the billing meter GUID is scheduled to change due to a new billing model, you will be notified in advance of the change. 
  ## 
  ## https://docs.microsoft.com/rest/api/commerce/ratecard
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : It uniquely identifies Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation. It ONLY supports the 'eq' and 'and' logical operators at this time. All the 4 query parameters 'OfferDurableId',  'Currency', 'Locale', 'Region' are required to be a part of the $filter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  var valid_568058 = query.getOrDefault("$filter")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "$filter", valid_568058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568081: Call_RateCardGet_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables you to query for the resource/meter metadata and related prices used in a given subscription by Offer ID, Currency, Locale and Region. The metadata associated with the billing meters, including but not limited to service names, types, resources, units of measure, and regions, is subject to change at any time and without notice. If you intend to use this billing data in an automated fashion, please use the billing meter GUID to uniquely identify each billable item. If the billing meter GUID is scheduled to change due to a new billing model, you will be notified in advance of the change. 
  ## 
  ## https://docs.microsoft.com/rest/api/commerce/ratecard
  let valid = call_568081.validator(path, query, header, formData, body)
  let scheme = call_568081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568081.url(scheme.get, call_568081.host, call_568081.base,
                         call_568081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568081, url, valid)

proc call*(call_568152: Call_RateCardGet_567880; apiVersion: string;
          subscriptionId: string; Filter: string): Recallable =
  ## rateCardGet
  ## Enables you to query for the resource/meter metadata and related prices used in a given subscription by Offer ID, Currency, Locale and Region. The metadata associated with the billing meters, including but not limited to service names, types, resources, units of measure, and regions, is subject to change at any time and without notice. If you intend to use this billing data in an automated fashion, please use the billing meter GUID to uniquely identify each billable item. If the billing meter GUID is scheduled to change due to a new billing model, you will be notified in advance of the change. 
  ## https://docs.microsoft.com/rest/api/commerce/ratecard
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : It uniquely identifies Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation. It ONLY supports the 'eq' and 'and' logical operators at this time. All the 4 query parameters 'OfferDurableId',  'Currency', 'Locale', 'Region' are required to be a part of the $filter.
  var path_568153 = newJObject()
  var query_568155 = newJObject()
  add(query_568155, "api-version", newJString(apiVersion))
  add(path_568153, "subscriptionId", newJString(subscriptionId))
  add(query_568155, "$filter", newJString(Filter))
  result = call_568152.call(path_568153, query_568155, nil, nil, nil)

var rateCardGet* = Call_RateCardGet_567880(name: "rateCardGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce/RateCard",
                                        validator: validate_RateCardGet_567881,
                                        base: "", url: url_RateCardGet_567882,
                                        schemes: {Scheme.Https})
type
  Call_UsageAggregatesList_568194 = ref object of OpenApiRestCall_567658
proc url_UsageAggregatesList_568196(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Commerce/UsageAggregates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageAggregatesList_568195(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Query aggregated Azure subscription consumption data for a date range.
  ## 
  ## https://docs.microsoft.com/rest/api/commerce/usageaggregates
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : It uniquely identifies Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   showDetails: JBool
  ##              : `True` returns usage data in instance-level detail, `false` causes server-side aggregation with fewer details. For example, if you have 3 website instances, by default you will get 3 line items for website consumption. If you specify showDetails = false, the data will be aggregated as a single line item for website consumption within the time period (for the given subscriptionId, meterId, usageStartTime and usageEndTime).
  ##   reportedStartTime: JString (required)
  ##                    : The start of the time range to retrieve data for.
  ##   reportedEndTime: JString (required)
  ##                  : The end of the time range to retrieve data for.
  ##   continuationToken: JString
  ##                    : Used when a continuation token string is provided in the response body of the previous call, enabling paging through a large result set. If not present, the data is retrieved from the beginning of the day/hour (based on the granularity) passed in. 
  ##   aggregationGranularity: JString
  ##                         : `Daily` (default) returns the data in daily granularity, `Hourly` returns the data in hourly granularity.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("showDetails")
  valid_568199 = validateParameter(valid_568199, JBool, required = false, default = nil)
  if valid_568199 != nil:
    section.add "showDetails", valid_568199
  var valid_568200 = query.getOrDefault("reportedStartTime")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "reportedStartTime", valid_568200
  var valid_568201 = query.getOrDefault("reportedEndTime")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "reportedEndTime", valid_568201
  var valid_568202 = query.getOrDefault("continuationToken")
  valid_568202 = validateParameter(valid_568202, JString, required = false,
                                 default = nil)
  if valid_568202 != nil:
    section.add "continuationToken", valid_568202
  var valid_568216 = query.getOrDefault("aggregationGranularity")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = newJString("Daily"))
  if valid_568216 != nil:
    section.add "aggregationGranularity", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_UsageAggregatesList_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query aggregated Azure subscription consumption data for a date range.
  ## 
  ## https://docs.microsoft.com/rest/api/commerce/usageaggregates
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_UsageAggregatesList_568194; apiVersion: string;
          subscriptionId: string; reportedStartTime: string;
          reportedEndTime: string; showDetails: bool = false;
          continuationToken: string = ""; aggregationGranularity: string = "Daily"): Recallable =
  ## usageAggregatesList
  ## Query aggregated Azure subscription consumption data for a date range.
  ## https://docs.microsoft.com/rest/api/commerce/usageaggregates
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   showDetails: bool
  ##              : `True` returns usage data in instance-level detail, `false` causes server-side aggregation with fewer details. For example, if you have 3 website instances, by default you will get 3 line items for website consumption. If you specify showDetails = false, the data will be aggregated as a single line item for website consumption within the time period (for the given subscriptionId, meterId, usageStartTime and usageEndTime).
  ##   subscriptionId: string (required)
  ##                 : It uniquely identifies Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   reportedStartTime: string (required)
  ##                    : The start of the time range to retrieve data for.
  ##   reportedEndTime: string (required)
  ##                  : The end of the time range to retrieve data for.
  ##   continuationToken: string
  ##                    : Used when a continuation token string is provided in the response body of the previous call, enabling paging through a large result set. If not present, the data is retrieved from the beginning of the day/hour (based on the granularity) passed in. 
  ##   aggregationGranularity: string
  ##                         : `Daily` (default) returns the data in daily granularity, `Hourly` returns the data in hourly granularity.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(query_568220, "showDetails", newJBool(showDetails))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(query_568220, "reportedStartTime", newJString(reportedStartTime))
  add(query_568220, "reportedEndTime", newJString(reportedEndTime))
  add(query_568220, "continuationToken", newJString(continuationToken))
  add(query_568220, "aggregationGranularity", newJString(aggregationGranularity))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var usageAggregatesList* = Call_UsageAggregatesList_568194(
    name: "usageAggregatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce/UsageAggregates",
    validator: validate_UsageAggregatesList_568195, base: "",
    url: url_UsageAggregatesList_568196, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
