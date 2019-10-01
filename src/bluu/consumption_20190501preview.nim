
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2019-05-01-preview
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  Call_BalancesGetForBillingPeriodByBillingAccount_567890 = ref object of OpenApiRestCall_567668
proc url_BalancesGetForBillingPeriodByBillingAccount_567892(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/balances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BalancesGetForBillingPeriodByBillingAccount_567891(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568065 = path.getOrDefault("billingPeriodName")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "billingPeriodName", valid_568065
  var valid_568066 = path.getOrDefault("billingAccountId")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "billingAccountId", valid_568066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568067 = query.getOrDefault("api-version")
  valid_568067 = validateParameter(valid_568067, JString, required = true,
                                 default = nil)
  if valid_568067 != nil:
    section.add "api-version", valid_568067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568090: Call_BalancesGetForBillingPeriodByBillingAccount_567890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568090.validator(path, query, header, formData, body)
  let scheme = call_568090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568090.url(scheme.get, call_568090.host, call_568090.base,
                         call_568090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568090, url, valid)

proc call*(call_568161: Call_BalancesGetForBillingPeriodByBillingAccount_567890;
          apiVersion: string; billingPeriodName: string; billingAccountId: string): Recallable =
  ## balancesGetForBillingPeriodByBillingAccount
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568162 = newJObject()
  var query_568164 = newJObject()
  add(query_568164, "api-version", newJString(apiVersion))
  add(path_568162, "billingPeriodName", newJString(billingPeriodName))
  add(path_568162, "billingAccountId", newJString(billingAccountId))
  result = call_568161.call(path_568162, query_568164, nil, nil, nil)

var balancesGetForBillingPeriodByBillingAccount* = Call_BalancesGetForBillingPeriodByBillingAccount_567890(
    name: "balancesGetForBillingPeriodByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/balances",
    validator: validate_BalancesGetForBillingPeriodByBillingAccount_567891,
    base: "", url: url_BalancesGetForBillingPeriodByBillingAccount_567892,
    schemes: {Scheme.Https})
type
  Call_BalancesGetByBillingAccount_568203 = ref object of OpenApiRestCall_567668
proc url_BalancesGetByBillingAccount_568205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/balances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BalancesGetByBillingAccount_568204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568206 = path.getOrDefault("billingAccountId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "billingAccountId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_BalancesGetByBillingAccount_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_BalancesGetByBillingAccount_568203;
          apiVersion: string; billingAccountId: string): Recallable =
  ## balancesGetByBillingAccount
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "billingAccountId", newJString(billingAccountId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var balancesGetByBillingAccount* = Call_BalancesGetByBillingAccount_568203(
    name: "balancesGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/balances",
    validator: validate_BalancesGetByBillingAccount_568204, base: "",
    url: url_BalancesGetByBillingAccount_568205, schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrder_568212 = ref object of OpenApiRestCall_567668
proc url_ReservationsDetailsListByReservationOrder_568214(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsListByReservationOrder_568213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568216 = path.getOrDefault("reservationOrderId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "reservationOrderId", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  var valid_568218 = query.getOrDefault("$filter")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "$filter", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_ReservationsDetailsListByReservationOrder_568212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_ReservationsDetailsListByReservationOrder_568212;
          apiVersion: string; reservationOrderId: string; Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrder
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "reservationOrderId", newJString(reservationOrderId))
  add(query_568222, "$filter", newJString(Filter))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var reservationsDetailsListByReservationOrder* = Call_ReservationsDetailsListByReservationOrder_568212(
    name: "reservationsDetailsListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsListByReservationOrder_568213,
    base: "", url: url_ReservationsDetailsListByReservationOrder_568214,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrder_568223 = ref object of OpenApiRestCall_567668
proc url_ReservationsSummariesListByReservationOrder_568225(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesListByReservationOrder_568224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568226 = path.getOrDefault("reservationOrderId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "reservationOrderId", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  var valid_568228 = query.getOrDefault("$filter")
  valid_568228 = validateParameter(valid_568228, JString, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "$filter", valid_568228
  var valid_568242 = query.getOrDefault("grain")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = newJString("daily"))
  if valid_568242 != nil:
    section.add "grain", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_ReservationsSummariesListByReservationOrder_568223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_ReservationsSummariesListByReservationOrder_568223;
          apiVersion: string; reservationOrderId: string; Filter: string = "";
          grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrder
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "reservationOrderId", newJString(reservationOrderId))
  add(query_568246, "$filter", newJString(Filter))
  add(query_568246, "grain", newJString(grain))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var reservationsSummariesListByReservationOrder* = Call_ReservationsSummariesListByReservationOrder_568223(
    name: "reservationsSummariesListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesListByReservationOrder_568224,
    base: "", url: url_ReservationsSummariesListByReservationOrder_568225,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrderAndReservation_568247 = ref object of OpenApiRestCall_567668
proc url_ReservationsDetailsListByReservationOrderAndReservation_568249(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsListByReservationOrderAndReservation_568248(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568250 = path.getOrDefault("reservationOrderId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "reservationOrderId", valid_568250
  var valid_568251 = path.getOrDefault("reservationId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "reservationId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  var valid_568253 = query.getOrDefault("$filter")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "$filter", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_ReservationsDetailsListByReservationOrderAndReservation_568247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_ReservationsDetailsListByReservationOrderAndReservation_568247;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrderAndReservation
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "reservationOrderId", newJString(reservationOrderId))
  add(path_568256, "reservationId", newJString(reservationId))
  add(query_568257, "$filter", newJString(Filter))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var reservationsDetailsListByReservationOrderAndReservation* = Call_ReservationsDetailsListByReservationOrderAndReservation_568247(
    name: "reservationsDetailsListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationDetails", validator: validate_ReservationsDetailsListByReservationOrderAndReservation_568248,
    base: "", url: url_ReservationsDetailsListByReservationOrderAndReservation_568249,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrderAndReservation_568258 = ref object of OpenApiRestCall_567668
proc url_ReservationsSummariesListByReservationOrderAndReservation_568260(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesListByReservationOrderAndReservation_568259(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568261 = path.getOrDefault("reservationOrderId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "reservationOrderId", valid_568261
  var valid_568262 = path.getOrDefault("reservationId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "reservationId", valid_568262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  var valid_568264 = query.getOrDefault("$filter")
  valid_568264 = validateParameter(valid_568264, JString, required = false,
                                 default = nil)
  if valid_568264 != nil:
    section.add "$filter", valid_568264
  var valid_568265 = query.getOrDefault("grain")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = newJString("daily"))
  if valid_568265 != nil:
    section.add "grain", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_ReservationsSummariesListByReservationOrderAndReservation_568258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_ReservationsSummariesListByReservationOrderAndReservation_568258;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string = ""; grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrderAndReservation
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "reservationOrderId", newJString(reservationOrderId))
  add(path_568268, "reservationId", newJString(reservationId))
  add(query_568269, "$filter", newJString(Filter))
  add(query_568269, "grain", newJString(grain))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var reservationsSummariesListByReservationOrderAndReservation* = Call_ReservationsSummariesListByReservationOrderAndReservation_568258(
    name: "reservationsSummariesListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationSummaries", validator: validate_ReservationsSummariesListByReservationOrderAndReservation_568259,
    base: "", url: url_ReservationsSummariesListByReservationOrderAndReservation_568260,
    schemes: {Scheme.Https})
type
  Call_OperationsList_568270 = ref object of OpenApiRestCall_567668
proc url_OperationsList_568272(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568271(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_OperationsList_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_OperationsList_568270; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  var query_568276 = newJObject()
  add(query_568276, "api-version", newJString(apiVersion))
  result = call_568275.call(nil, query_568276, nil, nil, nil)

var operationsList* = Call_OperationsList_568270(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_568271, base: "", url: url_OperationsList_568272,
    schemes: {Scheme.Https})
type
  Call_AggregatedCostGetForBillingPeriodByManagementGroup_568277 = ref object of OpenApiRestCall_567668
proc url_AggregatedCostGetForBillingPeriodByManagementGroup_568279(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/Microsoft.Consumption/aggregatedcost")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AggregatedCostGetForBillingPeriodByManagementGroup_568278(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568280 = path.getOrDefault("managementGroupId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "managementGroupId", valid_568280
  var valid_568281 = path.getOrDefault("billingPeriodName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "billingPeriodName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
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

proc call*(call_568283: Call_AggregatedCostGetForBillingPeriodByManagementGroup_568277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_AggregatedCostGetForBillingPeriodByManagementGroup_568277;
          apiVersion: string; managementGroupId: string; billingPeriodName: string): Recallable =
  ## aggregatedCostGetForBillingPeriodByManagementGroup
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "managementGroupId", newJString(managementGroupId))
  add(path_568285, "billingPeriodName", newJString(billingPeriodName))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var aggregatedCostGetForBillingPeriodByManagementGroup* = Call_AggregatedCostGetForBillingPeriodByManagementGroup_568277(
    name: "aggregatedCostGetForBillingPeriodByManagementGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/Microsoft.Consumption/aggregatedcost",
    validator: validate_AggregatedCostGetForBillingPeriodByManagementGroup_568278,
    base: "", url: url_AggregatedCostGetForBillingPeriodByManagementGroup_568279,
    schemes: {Scheme.Https})
type
  Call_AggregatedCostGetByManagementGroup_568287 = ref object of OpenApiRestCall_567668
proc url_AggregatedCostGetByManagementGroup_568289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/aggregatedcost")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AggregatedCostGetByManagementGroup_568288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568290 = path.getOrDefault("managementGroupId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "managementGroupId", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString
  ##          : May be used to filter aggregated cost by properties/usageStart (Utc time), properties/usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  var valid_568292 = query.getOrDefault("$filter")
  valid_568292 = validateParameter(valid_568292, JString, required = false,
                                 default = nil)
  if valid_568292 != nil:
    section.add "$filter", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_AggregatedCostGetByManagementGroup_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_AggregatedCostGetByManagementGroup_568287;
          apiVersion: string; managementGroupId: string; Filter: string = ""): Recallable =
  ## aggregatedCostGetByManagementGroup
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Filter: string
  ##         : May be used to filter aggregated cost by properties/usageStart (Utc time), properties/usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "managementGroupId", newJString(managementGroupId))
  add(query_568296, "$filter", newJString(Filter))
  result = call_568294.call(path_568295, query_568296, nil, nil, nil)

var aggregatedCostGetByManagementGroup* = Call_AggregatedCostGetByManagementGroup_568287(
    name: "aggregatedCostGetByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Consumption/aggregatedcost",
    validator: validate_AggregatedCostGetByManagementGroup_568288, base: "",
    url: url_AggregatedCostGetByManagementGroup_568289, schemes: {Scheme.Https})
type
  Call_PriceSheetGetByBillingPeriod_568297 = ref object of OpenApiRestCall_567668
proc url_PriceSheetGetByBillingPeriod_568299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/pricesheets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetGetByBillingPeriod_568298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  var valid_568301 = path.getOrDefault("billingPeriodName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "billingPeriodName", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_568302 = query.getOrDefault("$expand")
  valid_568302 = validateParameter(valid_568302, JString, required = false,
                                 default = nil)
  if valid_568302 != nil:
    section.add "$expand", valid_568302
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  var valid_568304 = query.getOrDefault("$top")
  valid_568304 = validateParameter(valid_568304, JInt, required = false, default = nil)
  if valid_568304 != nil:
    section.add "$top", valid_568304
  var valid_568305 = query.getOrDefault("$skiptoken")
  valid_568305 = validateParameter(valid_568305, JString, required = false,
                                 default = nil)
  if valid_568305 != nil:
    section.add "$skiptoken", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_PriceSheetGetByBillingPeriod_568297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_PriceSheetGetByBillingPeriod_568297;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## priceSheetGetByBillingPeriod
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(query_568309, "$expand", newJString(Expand))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(query_568309, "$top", newJInt(Top))
  add(query_568309, "$skiptoken", newJString(Skiptoken))
  add(path_568308, "billingPeriodName", newJString(billingPeriodName))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var priceSheetGetByBillingPeriod* = Call_PriceSheetGetByBillingPeriod_568297(
    name: "priceSheetGetByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGetByBillingPeriod_568298, base: "",
    url: url_PriceSheetGetByBillingPeriod_568299, schemes: {Scheme.Https})
type
  Call_ForecastsList_568310 = ref object of OpenApiRestCall_567668
proc url_ForecastsList_568312(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/forecasts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastsList_568311(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the forecast charges by subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString
  ##          : May be used to filter forecasts by properties/usageDate (Utc time), properties/chargeType or properties/grain. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  var valid_568315 = query.getOrDefault("$filter")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$filter", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_ForecastsList_568310; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the forecast charges by subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_ForecastsList_568310; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## forecastsList
  ## Lists the forecast charges by subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter forecasts by properties/usageDate (Utc time), properties/chargeType or properties/grain. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(query_568319, "$filter", newJString(Filter))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var forecastsList* = Call_ForecastsList_568310(name: "forecastsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/forecasts",
    validator: validate_ForecastsList_568311, base: "", url: url_ForecastsList_568312,
    schemes: {Scheme.Https})
type
  Call_PriceSheetGet_568320 = ref object of OpenApiRestCall_567668
proc url_PriceSheetGet_568322(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/pricesheets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetGet_568321(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_568324 = query.getOrDefault("$expand")
  valid_568324 = validateParameter(valid_568324, JString, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "$expand", valid_568324
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  var valid_568326 = query.getOrDefault("$top")
  valid_568326 = validateParameter(valid_568326, JInt, required = false, default = nil)
  if valid_568326 != nil:
    section.add "$top", valid_568326
  var valid_568327 = query.getOrDefault("$skiptoken")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "$skiptoken", valid_568327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568328: Call_PriceSheetGet_568320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568328.validator(path, query, header, formData, body)
  let scheme = call_568328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568328.url(scheme.get, call_568328.host, call_568328.base,
                         call_568328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568328, url, valid)

proc call*(call_568329: Call_PriceSheetGet_568320; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""): Recallable =
  ## priceSheetGet
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_568330 = newJObject()
  var query_568331 = newJObject()
  add(query_568331, "$expand", newJString(Expand))
  add(query_568331, "api-version", newJString(apiVersion))
  add(path_568330, "subscriptionId", newJString(subscriptionId))
  add(query_568331, "$top", newJInt(Top))
  add(query_568331, "$skiptoken", newJString(Skiptoken))
  result = call_568329.call(path_568330, query_568331, nil, nil, nil)

var priceSheetGet* = Call_PriceSheetGet_568320(name: "priceSheetGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGet_568321, base: "", url: url_PriceSheetGet_568322,
    schemes: {Scheme.Https})
type
  Call_ReservationRecommendationsList_568332 = ref object of OpenApiRestCall_567668
proc url_ReservationRecommendationsList_568334(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/reservationRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationRecommendationsList_568333(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString
  ##          : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  var valid_568337 = query.getOrDefault("$filter")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "$filter", valid_568337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_ReservationRecommendationsList_568332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_ReservationRecommendationsList_568332;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## reservationRecommendationsList
  ## List of recommendations for purchasing reserved instances.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  add(query_568341, "$filter", newJString(Filter))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var reservationRecommendationsList* = Call_ReservationRecommendationsList_568332(
    name: "reservationRecommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/reservationRecommendations",
    validator: validate_ReservationRecommendationsList_568333, base: "",
    url: url_ReservationRecommendationsList_568334, schemes: {Scheme.Https})
type
  Call_BudgetsList_568342 = ref object of OpenApiRestCall_567668
proc url_BudgetsList_568344(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsList_568343(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568345 = path.getOrDefault("scope")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "scope", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_BudgetsList_568342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_BudgetsList_568342; apiVersion: string; scope: string): Recallable =
  ## budgetsList
  ## Lists all budgets for the defined scope.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "scope", newJString(scope))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var budgetsList* = Call_BudgetsList_568342(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/{scope}/providers/Microsoft.Consumption/budgets",
                                        validator: validate_BudgetsList_568343,
                                        base: "", url: url_BudgetsList_568344,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdate_568361 = ref object of OpenApiRestCall_567668
proc url_BudgetsCreateOrUpdate_568363(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdate_568362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568364 = path.getOrDefault("scope")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "scope", valid_568364
  var valid_568365 = path.getOrDefault("budgetName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "budgetName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_BudgetsCreateOrUpdate_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_BudgetsCreateOrUpdate_568361; apiVersion: string;
          parameters: JsonNode; scope: string; budgetName: string): Recallable =
  ## budgetsCreateOrUpdate
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  var body_568372 = newJObject()
  add(query_568371, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568372 = parameters
  add(path_568370, "scope", newJString(scope))
  add(path_568370, "budgetName", newJString(budgetName))
  result = call_568369.call(path_568370, query_568371, nil, nil, body_568372)

var budgetsCreateOrUpdate* = Call_BudgetsCreateOrUpdate_568361(
    name: "budgetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdate_568362, base: "",
    url: url_BudgetsCreateOrUpdate_568363, schemes: {Scheme.Https})
type
  Call_BudgetsGet_568351 = ref object of OpenApiRestCall_567668
proc url_BudgetsGet_568353(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGet_568352(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for the scope by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568354 = path.getOrDefault("scope")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "scope", valid_568354
  var valid_568355 = path.getOrDefault("budgetName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "budgetName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
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
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_BudgetsGet_568351; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for the scope by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_BudgetsGet_568351; apiVersion: string; scope: string;
          budgetName: string): Recallable =
  ## budgetsGet
  ## Gets the budget for the scope by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "scope", newJString(scope))
  add(path_568359, "budgetName", newJString(budgetName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var budgetsGet* = Call_BudgetsGet_568351(name: "budgetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/{scope}/providers/Microsoft.Consumption/budgets/{budgetName}",
                                      validator: validate_BudgetsGet_568352,
                                      base: "", url: url_BudgetsGet_568353,
                                      schemes: {Scheme.Https})
type
  Call_BudgetsDelete_568373 = ref object of OpenApiRestCall_567668
proc url_BudgetsDelete_568375(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDelete_568374(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568376 = path.getOrDefault("scope")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "scope", valid_568376
  var valid_568377 = path.getOrDefault("budgetName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "budgetName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
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

proc call*(call_568379: Call_BudgetsDelete_568373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_BudgetsDelete_568373; apiVersion: string; scope: string;
          budgetName: string): Recallable =
  ## budgetsDelete
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   scope: string (required)
  ##        : The scope associated with budget operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope, '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}' for billingProfile scope, 
  ## 'providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}' for invoiceSection scope.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "scope", newJString(scope))
  add(path_568381, "budgetName", newJString(budgetName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var budgetsDelete* = Call_BudgetsDelete_568373(name: "budgetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDelete_568374, base: "", url: url_BudgetsDelete_568375,
    schemes: {Scheme.Https})
type
  Call_ChargesListByScope_568383 = ref object of OpenApiRestCall_567668
proc url_ChargesListByScope_568385(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesListByScope_568384(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the charges based for the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with usage details operations. This includes 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope. For department and enrollment accounts, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568386 = path.getOrDefault("scope")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "scope", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  var valid_568388 = query.getOrDefault("$filter")
  valid_568388 = validateParameter(valid_568388, JString, required = false,
                                 default = nil)
  if valid_568388 != nil:
    section.add "$filter", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_ChargesListByScope_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges based for the defined scope.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_ChargesListByScope_568383; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## chargesListByScope
  ## Lists the charges based for the defined scope.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   scope: string (required)
  ##        : The scope associated with usage details operations. This includes 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope and 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope. For department and enrollment accounts, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "scope", newJString(scope))
  add(query_568392, "$filter", newJString(Filter))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var chargesListByScope* = Call_ChargesListByScope_568383(
    name: "chargesListByScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListByScope_568384, base: "",
    url: url_ChargesListByScope_568385, schemes: {Scheme.Https})
type
  Call_MarketplacesList_568393 = ref object of OpenApiRestCall_567668
proc url_MarketplacesList_568395(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesList_568394(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope at the defined scope. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with marketplace operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, '/providers/Microsoft.Billing/departments/{departmentId}' for Department scope, '/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope. For subscription, billing account, department, enrollment account and ManagementGroup, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568396 = path.getOrDefault("scope")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "scope", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  var valid_568398 = query.getOrDefault("$top")
  valid_568398 = validateParameter(valid_568398, JInt, required = false, default = nil)
  if valid_568398 != nil:
    section.add "$top", valid_568398
  var valid_568399 = query.getOrDefault("$skiptoken")
  valid_568399 = validateParameter(valid_568399, JString, required = false,
                                 default = nil)
  if valid_568399 != nil:
    section.add "$skiptoken", valid_568399
  var valid_568400 = query.getOrDefault("$filter")
  valid_568400 = validateParameter(valid_568400, JString, required = false,
                                 default = nil)
  if valid_568400 != nil:
    section.add "$filter", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_MarketplacesList_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope at the defined scope. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_MarketplacesList_568393; apiVersion: string;
          scope: string; Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesList
  ## Lists the marketplaces for a scope at the defined scope. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   scope: string (required)
  ##        : The scope associated with marketplace operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, '/providers/Microsoft.Billing/departments/{departmentId}' for Department scope, '/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope. For subscription, billing account, department, enrollment account and ManagementGroup, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(query_568404, "api-version", newJString(apiVersion))
  add(query_568404, "$top", newJInt(Top))
  add(query_568404, "$skiptoken", newJString(Skiptoken))
  add(path_568403, "scope", newJString(scope))
  add(query_568404, "$filter", newJString(Filter))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var marketplacesList* = Call_MarketplacesList_568393(name: "marketplacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesList_568394, base: "",
    url: url_MarketplacesList_568395, schemes: {Scheme.Https})
type
  Call_TagsGet_568405 = ref object of OpenApiRestCall_567668
proc url_TagsGet_568407(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsGet_568406(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all available tag keys for the defined scope
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with tags operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope..
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568408 = path.getOrDefault("scope")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "scope", valid_568408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568409 = query.getOrDefault("api-version")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "api-version", valid_568409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568410: Call_TagsGet_568405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all available tag keys for the defined scope
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568410.validator(path, query, header, formData, body)
  let scheme = call_568410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568410.url(scheme.get, call_568410.host, call_568410.base,
                         call_568410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568410, url, valid)

proc call*(call_568411: Call_TagsGet_568405; apiVersion: string; scope: string): Recallable =
  ## tagsGet
  ## Get all available tag keys for the defined scope
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   scope: string (required)
  ##        : The scope associated with tags operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}' for Department scope, 
  ## '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope..
  var path_568412 = newJObject()
  var query_568413 = newJObject()
  add(query_568413, "api-version", newJString(apiVersion))
  add(path_568412, "scope", newJString(scope))
  result = call_568411.call(path_568412, query_568413, nil, nil, nil)

var tagsGet* = Call_TagsGet_568405(name: "tagsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/{scope}/providers/Microsoft.Consumption/tags",
                                validator: validate_TagsGet_568406, base: "",
                                url: url_TagsGet_568407, schemes: {Scheme.Https})
type
  Call_UsageDetailsList_568414 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsList_568416(protocol: Scheme; host: string; base: string;
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

proc validate_UsageDetailsList_568415(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the usage details for the defined scope. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with usage details operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, '/providers/Microsoft.Billing/departments/{departmentId}' for Department scope, '/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope. For subscription, billing account, department, enrollment account and management group, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568417 = path.getOrDefault("scope")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "scope", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalInfo or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   metric: JString
  ##         : Allows to select different type of cost/usage records.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/resourceGroup, properties/resourceName, properties/resourceId, properties/chargeType, properties/reservationId, properties/publisherType or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:). PublisherType Filter accepts two values azure and marketplace and it is currently supported for Web Direct Offer Type
  section = newJObject()
  var valid_568418 = query.getOrDefault("$expand")
  valid_568418 = validateParameter(valid_568418, JString, required = false,
                                 default = nil)
  if valid_568418 != nil:
    section.add "$expand", valid_568418
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
  var valid_568421 = query.getOrDefault("$skiptoken")
  valid_568421 = validateParameter(valid_568421, JString, required = false,
                                 default = nil)
  if valid_568421 != nil:
    section.add "$skiptoken", valid_568421
  var valid_568422 = query.getOrDefault("metric")
  valid_568422 = validateParameter(valid_568422, JString, required = false,
                                 default = newJString("actualcost"))
  if valid_568422 != nil:
    section.add "metric", valid_568422
  var valid_568423 = query.getOrDefault("$filter")
  valid_568423 = validateParameter(valid_568423, JString, required = false,
                                 default = nil)
  if valid_568423 != nil:
    section.add "$filter", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_UsageDetailsList_568414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for the defined scope. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_UsageDetailsList_568414; apiVersion: string;
          scope: string; Expand: string = ""; Top: int = 0; Skiptoken: string = "";
          metric: string = "actualcost"; Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for the defined scope. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalInfo or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   metric: string
  ##         : Allows to select different type of cost/usage records.
  ##   scope: string (required)
  ##        : The scope associated with usage details operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, '/providers/Microsoft.Billing/departments/{departmentId}' for Department scope, '/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope. For subscription, billing account, department, enrollment account and management group, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/resourceGroup, properties/resourceName, properties/resourceId, properties/chargeType, properties/reservationId, properties/publisherType or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:). PublisherType Filter accepts two values azure and marketplace and it is currently supported for Web Direct Offer Type
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  add(query_568427, "$expand", newJString(Expand))
  add(query_568427, "api-version", newJString(apiVersion))
  add(query_568427, "$top", newJInt(Top))
  add(query_568427, "$skiptoken", newJString(Skiptoken))
  add(query_568427, "metric", newJString(metric))
  add(path_568426, "scope", newJString(scope))
  add(query_568427, "$filter", newJString(Filter))
  result = call_568425.call(path_568426, query_568427, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_568414(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_568415, base: "",
    url: url_UsageDetailsList_568416, schemes: {Scheme.Https})
type
  Call_UsageDetailsDownload_568428 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsDownload_568430(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsDownload_568429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Download usage details data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope associated with usage details operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, '/providers/Microsoft.Billing/departments/{departmentId}' for Department scope, '/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope. For subscription, billing account, department, enrollment account and management group, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568431 = path.getOrDefault("scope")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "scope", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   metric: JString
  ##         : Allows to select different type of cost/usage records.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/resourceGroup, properties/resourceName, properties/resourceId, properties/chargeType, properties/reservationId, properties/publisherType or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:). PublisherType Filter accepts two values azure and marketplace and it is currently supported for Web Direct Offer Type
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  var valid_568433 = query.getOrDefault("metric")
  valid_568433 = validateParameter(valid_568433, JString, required = false,
                                 default = newJString("actualcost"))
  if valid_568433 != nil:
    section.add "metric", valid_568433
  var valid_568434 = query.getOrDefault("$filter")
  valid_568434 = validateParameter(valid_568434, JString, required = false,
                                 default = nil)
  if valid_568434 != nil:
    section.add "$filter", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_UsageDetailsDownload_568428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Download usage details data.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_UsageDetailsDownload_568428; apiVersion: string;
          scope: string; metric: string = "actualcost"; Filter: string = ""): Recallable =
  ## usageDetailsDownload
  ## Download usage details data.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-05-01-preview.
  ##   metric: string
  ##         : Allows to select different type of cost/usage records.
  ##   scope: string (required)
  ##        : The scope associated with usage details operations. This includes '/subscriptions/{subscriptionId}/' for subscription scope, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for resourceGroup scope, '/providers/Microsoft.Billing/billingAccounts/{billingAccountId}' for Billing Account scope, '/providers/Microsoft.Billing/departments/{departmentId}' for Department scope, '/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}' for EnrollmentAccount scope and '/providers/Microsoft.Management/managementGroups/{managementGroupId}' for Management Group scope. For subscription, billing account, department, enrollment account and management group, you can also add billing period to the scope using '/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'. For e.g. to specify billing period at department scope use 
  ## '/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}'
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/resourceGroup, properties/resourceName, properties/resourceId, properties/chargeType, properties/reservationId, properties/publisherType or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:). PublisherType Filter accepts two values azure and marketplace and it is currently supported for Web Direct Offer Type
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(query_568438, "api-version", newJString(apiVersion))
  add(query_568438, "metric", newJString(metric))
  add(path_568437, "scope", newJString(scope))
  add(query_568438, "$filter", newJString(Filter))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var usageDetailsDownload* = Call_UsageDetailsDownload_568428(
    name: "usageDetailsDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/usageDetails/download",
    validator: validate_UsageDetailsDownload_568429, base: "",
    url: url_UsageDetailsDownload_568430, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
