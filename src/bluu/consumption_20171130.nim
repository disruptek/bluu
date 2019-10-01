
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2017-11-30
## termsOfService: (not provided)
## license: (not provided)
## 
## Consumption management client provides access to consumption resources for Azure Enterprise Subscriptions.
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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  macServiceName = "consumption"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567881 = ref object of OpenApiRestCall_567659
proc url_OperationsList_567883(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567882(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available consumption REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-30.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568065: Call_OperationsList_567881; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_OperationsList_567881; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-30.
  var query_568137 = newJObject()
  add(query_568137, "api-version", newJString(apiVersion))
  result = call_568136.call(nil, query_568137, nil, nil, nil)

var operationsList* = Call_OperationsList_567881(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_567882, base: "", url: url_OperationsList_567883,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsList_568177 = ref object of OpenApiRestCall_567659
proc url_ReservationsDetailsList_568179(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsList_568178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the reservation details. The scope can be 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}' or 
  ## 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}/reservations/{ReservationId}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568195 = path.getOrDefault("scope")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "scope", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-30.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  var valid_568197 = query.getOrDefault("$filter")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "$filter", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ReservationsDetailsList_568177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ReservationsDetailsList_568177; apiVersion: string;
          scope: string; Filter: string): Recallable =
  ## reservationsDetailsList
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-30.
  ##   scope: string (required)
  ##        : The scope of the reservation details. The scope can be 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}' or 
  ## 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}/reservations/{ReservationId}'
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "scope", newJString(scope))
  add(query_568201, "$filter", newJString(Filter))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var reservationsDetailsList* = Call_ReservationsDetailsList_568177(
    name: "reservationsDetailsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsList_568178, base: "",
    url: url_ReservationsDetailsList_568179, schemes: {Scheme.Https})
type
  Call_ReservationsSummariesList_568202 = ref object of OpenApiRestCall_567659
proc url_ReservationsSummariesList_568204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesList_568203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the reservation summaries. The scope can be 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}' or 
  ## 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}/reservations/{ReservationId}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568205 = path.getOrDefault("scope")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "scope", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-30.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  var valid_568207 = query.getOrDefault("$filter")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "$filter", valid_568207
  var valid_568221 = query.getOrDefault("grain")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = newJString("daily"))
  if valid_568221 != nil:
    section.add "grain", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_ReservationsSummariesList_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_ReservationsSummariesList_568202; apiVersion: string;
          scope: string; Filter: string = ""; grain: string = "daily"): Recallable =
  ## reservationsSummariesList
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-30.
  ##   scope: string (required)
  ##        : The scope of the reservation summaries. The scope can be 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}' or 
  ## 'providers/Microsoft.Capacity/reservationorders/{ReservationOrderId}/reservations/{ReservationId}'
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "scope", newJString(scope))
  add(query_568225, "$filter", newJString(Filter))
  add(query_568225, "grain", newJString(grain))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var reservationsSummariesList* = Call_ReservationsSummariesList_568202(
    name: "reservationsSummariesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesList_568203, base: "",
    url: url_ReservationsSummariesList_568204, schemes: {Scheme.Https})
type
  Call_UsageDetailsList_568226 = ref object of OpenApiRestCall_567659
proc url_UsageDetailsList_568228(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsList_568227(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the usage details. The scope can be '/subscriptions/{subscriptionId}' for a subscription, or 
  ## '/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}' for a billing period.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568229 = path.getOrDefault("scope")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "scope", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-30.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_568230 = query.getOrDefault("$expand")
  valid_568230 = validateParameter(valid_568230, JString, required = false,
                                 default = nil)
  if valid_568230 != nil:
    section.add "$expand", valid_568230
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  var valid_568232 = query.getOrDefault("$top")
  valid_568232 = validateParameter(valid_568232, JInt, required = false, default = nil)
  if valid_568232 != nil:
    section.add "$top", valid_568232
  var valid_568233 = query.getOrDefault("$skiptoken")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = nil)
  if valid_568233 != nil:
    section.add "$skiptoken", valid_568233
  var valid_568234 = query.getOrDefault("$filter")
  valid_568234 = validateParameter(valid_568234, JString, required = false,
                                 default = nil)
  if valid_568234 != nil:
    section.add "$filter", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_UsageDetailsList_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_UsageDetailsList_568226; apiVersion: string;
          scope: string; Expand: string = ""; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-30.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   scope: string (required)
  ##        : The scope of the usage details. The scope can be '/subscriptions/{subscriptionId}' for a subscription, or 
  ## '/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}' for a billing period.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(query_568238, "$expand", newJString(Expand))
  add(query_568238, "api-version", newJString(apiVersion))
  add(query_568238, "$top", newJInt(Top))
  add(query_568238, "$skiptoken", newJString(Skiptoken))
  add(path_568237, "scope", newJString(scope))
  add(query_568238, "$filter", newJString(Filter))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_568226(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_568227, base: "",
    url: url_UsageDetailsList_568228, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
