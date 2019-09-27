
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2018-01-31
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_ReservationsDetailsListByReservationOrder_593647 = ref object of OpenApiRestCall_593425
proc url_ReservationsDetailsListByReservationOrder_593649(protocol: Scheme;
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

proc validate_ReservationsDetailsListByReservationOrder_593648(path: JsonNode;
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
  var valid_593823 = path.getOrDefault("reservationOrderId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "reservationOrderId", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  var valid_593825 = query.getOrDefault("$filter")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "$filter", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_ReservationsDetailsListByReservationOrder_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_ReservationsDetailsListByReservationOrder_593647;
          apiVersion: string; reservationOrderId: string; Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrder
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  add(query_593922, "api-version", newJString(apiVersion))
  add(path_593920, "reservationOrderId", newJString(reservationOrderId))
  add(query_593922, "$filter", newJString(Filter))
  result = call_593919.call(path_593920, query_593922, nil, nil, nil)

var reservationsDetailsListByReservationOrder* = Call_ReservationsDetailsListByReservationOrder_593647(
    name: "reservationsDetailsListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsListByReservationOrder_593648,
    base: "", url: url_ReservationsDetailsListByReservationOrder_593649,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrder_593961 = ref object of OpenApiRestCall_593425
proc url_ReservationsSummariesListByReservationOrder_593963(protocol: Scheme;
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

proc validate_ReservationsSummariesListByReservationOrder_593962(path: JsonNode;
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
  var valid_593964 = path.getOrDefault("reservationOrderId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "reservationOrderId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  var valid_593966 = query.getOrDefault("$filter")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "$filter", valid_593966
  var valid_593980 = query.getOrDefault("grain")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = newJString("daily"))
  if valid_593980 != nil:
    section.add "grain", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_ReservationsSummariesListByReservationOrder_593961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_ReservationsSummariesListByReservationOrder_593961;
          apiVersion: string; reservationOrderId: string; Filter: string = "";
          grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrder
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "reservationOrderId", newJString(reservationOrderId))
  add(query_593984, "$filter", newJString(Filter))
  add(query_593984, "grain", newJString(grain))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var reservationsSummariesListByReservationOrder* = Call_ReservationsSummariesListByReservationOrder_593961(
    name: "reservationsSummariesListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesListByReservationOrder_593962,
    base: "", url: url_ReservationsSummariesListByReservationOrder_593963,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrderAndReservation_593985 = ref object of OpenApiRestCall_593425
proc url_ReservationsDetailsListByReservationOrderAndReservation_593987(
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

proc validate_ReservationsDetailsListByReservationOrderAndReservation_593986(
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
  var valid_593988 = path.getOrDefault("reservationOrderId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "reservationOrderId", valid_593988
  var valid_593989 = path.getOrDefault("reservationId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "reservationId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  var valid_593991 = query.getOrDefault("$filter")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$filter", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_ReservationsDetailsListByReservationOrderAndReservation_593985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_ReservationsDetailsListByReservationOrderAndReservation_593985;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrderAndReservation
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "reservationOrderId", newJString(reservationOrderId))
  add(path_593994, "reservationId", newJString(reservationId))
  add(query_593995, "$filter", newJString(Filter))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var reservationsDetailsListByReservationOrderAndReservation* = Call_ReservationsDetailsListByReservationOrderAndReservation_593985(
    name: "reservationsDetailsListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationDetails", validator: validate_ReservationsDetailsListByReservationOrderAndReservation_593986,
    base: "", url: url_ReservationsDetailsListByReservationOrderAndReservation_593987,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrderAndReservation_593996 = ref object of OpenApiRestCall_593425
proc url_ReservationsSummariesListByReservationOrderAndReservation_593998(
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

proc validate_ReservationsSummariesListByReservationOrderAndReservation_593997(
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
  var valid_593999 = path.getOrDefault("reservationOrderId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "reservationOrderId", valid_593999
  var valid_594000 = path.getOrDefault("reservationId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "reservationId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("$filter")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "$filter", valid_594002
  var valid_594003 = query.getOrDefault("grain")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("daily"))
  if valid_594003 != nil:
    section.add "grain", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_ReservationsSummariesListByReservationOrderAndReservation_593996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_ReservationsSummariesListByReservationOrderAndReservation_593996;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string = ""; grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrderAndReservation
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "reservationOrderId", newJString(reservationOrderId))
  add(path_594006, "reservationId", newJString(reservationId))
  add(query_594007, "$filter", newJString(Filter))
  add(query_594007, "grain", newJString(grain))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var reservationsSummariesListByReservationOrderAndReservation* = Call_ReservationsSummariesListByReservationOrderAndReservation_593996(
    name: "reservationsSummariesListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationSummaries", validator: validate_ReservationsSummariesListByReservationOrderAndReservation_593997,
    base: "", url: url_ReservationsSummariesListByReservationOrderAndReservation_593998,
    schemes: {Scheme.Https})
type
  Call_OperationsList_594008 = ref object of OpenApiRestCall_593425
proc url_OperationsList_594010(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594009(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_OperationsList_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_OperationsList_594008; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  result = call_594013.call(nil, query_594014, nil, nil, nil)

var operationsList* = Call_OperationsList_594008(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_594009, base: "", url: url_OperationsList_594010,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingPeriod_594015 = ref object of OpenApiRestCall_593425
proc url_MarketplacesListByBillingPeriod_594017(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByBillingPeriod_594016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
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
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  var valid_594019 = path.getOrDefault("billingPeriodName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "billingPeriodName", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  var valid_594021 = query.getOrDefault("$top")
  valid_594021 = validateParameter(valid_594021, JInt, required = false, default = nil)
  if valid_594021 != nil:
    section.add "$top", valid_594021
  var valid_594022 = query.getOrDefault("$skiptoken")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "$skiptoken", valid_594022
  var valid_594023 = query.getOrDefault("$filter")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "$filter", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_MarketplacesListByBillingPeriod_594015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_MarketplacesListByBillingPeriod_594015;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "subscriptionId", newJString(subscriptionId))
  add(query_594027, "$top", newJInt(Top))
  add(query_594027, "$skiptoken", newJString(Skiptoken))
  add(path_594026, "billingPeriodName", newJString(billingPeriodName))
  add(query_594027, "$filter", newJString(Filter))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var marketplacesListByBillingPeriod* = Call_MarketplacesListByBillingPeriod_594015(
    name: "marketplacesListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingPeriod_594016, base: "",
    url: url_MarketplacesListByBillingPeriod_594017, schemes: {Scheme.Https})
type
  Call_PriceSheetGetByBillingPeriod_594028 = ref object of OpenApiRestCall_593425
proc url_PriceSheetGetByBillingPeriod_594030(protocol: Scheme; host: string;
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

proc validate_PriceSheetGetByBillingPeriod_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  var valid_594032 = path.getOrDefault("billingPeriodName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "billingPeriodName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_594033 = query.getOrDefault("$expand")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "$expand", valid_594033
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  var valid_594035 = query.getOrDefault("$top")
  valid_594035 = validateParameter(valid_594035, JInt, required = false, default = nil)
  if valid_594035 != nil:
    section.add "$top", valid_594035
  var valid_594036 = query.getOrDefault("$skiptoken")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "$skiptoken", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_PriceSheetGetByBillingPeriod_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_PriceSheetGetByBillingPeriod_594028;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## priceSheetGetByBillingPeriod
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(query_594040, "$expand", newJString(Expand))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(query_594040, "$top", newJInt(Top))
  add(query_594040, "$skiptoken", newJString(Skiptoken))
  add(path_594039, "billingPeriodName", newJString(billingPeriodName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var priceSheetGetByBillingPeriod* = Call_PriceSheetGetByBillingPeriod_594028(
    name: "priceSheetGetByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGetByBillingPeriod_594029, base: "",
    url: url_PriceSheetGetByBillingPeriod_594030, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingPeriod_594041 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsListByBillingPeriod_594043(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByBillingPeriod_594042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
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
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  var valid_594045 = path.getOrDefault("billingPeriodName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "billingPeriodName", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_594046 = query.getOrDefault("$expand")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "$expand", valid_594046
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  var valid_594048 = query.getOrDefault("$top")
  valid_594048 = validateParameter(valid_594048, JInt, required = false, default = nil)
  if valid_594048 != nil:
    section.add "$top", valid_594048
  var valid_594049 = query.getOrDefault("$skiptoken")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "$skiptoken", valid_594049
  var valid_594050 = query.getOrDefault("$filter")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "$filter", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_UsageDetailsListByBillingPeriod_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_UsageDetailsListByBillingPeriod_594041;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListByBillingPeriod
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(query_594054, "$expand", newJString(Expand))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(query_594054, "$top", newJInt(Top))
  add(query_594054, "$skiptoken", newJString(Skiptoken))
  add(path_594053, "billingPeriodName", newJString(billingPeriodName))
  add(query_594054, "$filter", newJString(Filter))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var usageDetailsListByBillingPeriod* = Call_UsageDetailsListByBillingPeriod_594041(
    name: "usageDetailsListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingPeriod_594042, base: "",
    url: url_UsageDetailsListByBillingPeriod_594043, schemes: {Scheme.Https})
type
  Call_BudgetsList_594055 = ref object of OpenApiRestCall_593425
proc url_BudgetsList_594057(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsList_594056(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a subscription.
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
  var valid_594058 = path.getOrDefault("subscriptionId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "subscriptionId", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_BudgetsList_594055; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_BudgetsList_594055; apiVersion: string;
          subscriptionId: string): Recallable =
  ## budgetsList
  ## Lists all budgets for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var budgetsList* = Call_BudgetsList_594055(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets",
                                        validator: validate_BudgetsList_594056,
                                        base: "", url: url_BudgetsList_594057,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdate_594074 = ref object of OpenApiRestCall_593425
proc url_BudgetsCreateOrUpdate_594076(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdate_594075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594077 = path.getOrDefault("subscriptionId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "subscriptionId", valid_594077
  var valid_594078 = path.getOrDefault("budgetName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "budgetName", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
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

proc call*(call_594081: Call_BudgetsCreateOrUpdate_594074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_BudgetsCreateOrUpdate_594074; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; budgetName: string): Recallable =
  ## budgetsCreateOrUpdate
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  var body_594085 = newJObject()
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594085 = parameters
  add(path_594083, "budgetName", newJString(budgetName))
  result = call_594082.call(path_594083, query_594084, nil, nil, body_594085)

var budgetsCreateOrUpdate* = Call_BudgetsCreateOrUpdate_594074(
    name: "budgetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdate_594075, base: "",
    url: url_BudgetsCreateOrUpdate_594076, schemes: {Scheme.Https})
type
  Call_BudgetsGet_594064 = ref object of OpenApiRestCall_593425
proc url_BudgetsGet_594066(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGet_594065(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("budgetName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "budgetName", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_BudgetsGet_594064; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_BudgetsGet_594064; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsGet
  ## Gets the budget for a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  add(query_594073, "api-version", newJString(apiVersion))
  add(path_594072, "subscriptionId", newJString(subscriptionId))
  add(path_594072, "budgetName", newJString(budgetName))
  result = call_594071.call(path_594072, query_594073, nil, nil, nil)

var budgetsGet* = Call_BudgetsGet_594064(name: "budgetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
                                      validator: validate_BudgetsGet_594065,
                                      base: "", url: url_BudgetsGet_594066,
                                      schemes: {Scheme.Https})
type
  Call_BudgetsDelete_594086 = ref object of OpenApiRestCall_593425
proc url_BudgetsDelete_594088(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDelete_594087(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594089 = path.getOrDefault("subscriptionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "subscriptionId", valid_594089
  var valid_594090 = path.getOrDefault("budgetName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "budgetName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594092: Call_BudgetsDelete_594086; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_BudgetsDelete_594086; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsDelete
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_594094 = newJObject()
  var query_594095 = newJObject()
  add(query_594095, "api-version", newJString(apiVersion))
  add(path_594094, "subscriptionId", newJString(subscriptionId))
  add(path_594094, "budgetName", newJString(budgetName))
  result = call_594093.call(path_594094, query_594095, nil, nil, nil)

var budgetsDelete* = Call_BudgetsDelete_594086(name: "budgetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDelete_594087, base: "", url: url_BudgetsDelete_594088,
    schemes: {Scheme.Https})
type
  Call_MarketplacesList_594096 = ref object of OpenApiRestCall_593425
proc url_MarketplacesList_594098(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesList_594097(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
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
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  var valid_594101 = query.getOrDefault("$top")
  valid_594101 = validateParameter(valid_594101, JInt, required = false, default = nil)
  if valid_594101 != nil:
    section.add "$top", valid_594101
  var valid_594102 = query.getOrDefault("$skiptoken")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "$skiptoken", valid_594102
  var valid_594103 = query.getOrDefault("$filter")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "$filter", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_MarketplacesList_594096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_MarketplacesList_594096; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesList
  ## Lists the marketplaces for a scope by subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  add(query_594107, "$top", newJInt(Top))
  add(query_594107, "$skiptoken", newJString(Skiptoken))
  add(query_594107, "$filter", newJString(Filter))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var marketplacesList* = Call_MarketplacesList_594096(name: "marketplacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesList_594097, base: "",
    url: url_MarketplacesList_594098, schemes: {Scheme.Https})
type
  Call_PriceSheetGet_594108 = ref object of OpenApiRestCall_593425
proc url_PriceSheetGet_594110(protocol: Scheme; host: string; base: string;
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

proc validate_PriceSheetGet_594109(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_594112 = query.getOrDefault("$expand")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "$expand", valid_594112
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  var valid_594114 = query.getOrDefault("$top")
  valid_594114 = validateParameter(valid_594114, JInt, required = false, default = nil)
  if valid_594114 != nil:
    section.add "$top", valid_594114
  var valid_594115 = query.getOrDefault("$skiptoken")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "$skiptoken", valid_594115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_PriceSheetGet_594108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_PriceSheetGet_594108; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""): Recallable =
  ## priceSheetGet
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  add(query_594119, "$expand", newJString(Expand))
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "subscriptionId", newJString(subscriptionId))
  add(query_594119, "$top", newJInt(Top))
  add(query_594119, "$skiptoken", newJString(Skiptoken))
  result = call_594117.call(path_594118, query_594119, nil, nil, nil)

var priceSheetGet* = Call_PriceSheetGet_594108(name: "priceSheetGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGet_594109, base: "", url: url_PriceSheetGet_594110,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsList_594120 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsList_594122(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsList_594121(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
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
  var valid_594123 = path.getOrDefault("subscriptionId")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "subscriptionId", valid_594123
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_594124 = query.getOrDefault("$expand")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "$expand", valid_594124
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594125 = query.getOrDefault("api-version")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "api-version", valid_594125
  var valid_594126 = query.getOrDefault("$top")
  valid_594126 = validateParameter(valid_594126, JInt, required = false, default = nil)
  if valid_594126 != nil:
    section.add "$top", valid_594126
  var valid_594127 = query.getOrDefault("$skiptoken")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "$skiptoken", valid_594127
  var valid_594128 = query.getOrDefault("$filter")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "$filter", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_UsageDetailsList_594120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_UsageDetailsList_594120; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(query_594132, "$expand", newJString(Expand))
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(query_594132, "$top", newJInt(Top))
  add(query_594132, "$skiptoken", newJString(Skiptoken))
  add(query_594132, "$filter", newJString(Filter))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_594120(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_594121, base: "",
    url: url_UsageDetailsList_594122, schemes: {Scheme.Https})
type
  Call_BudgetsListByResourceGroupName_594133 = ref object of OpenApiRestCall_593425
proc url_BudgetsListByResourceGroupName_594135(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsListByResourceGroupName_594134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594136 = path.getOrDefault("resourceGroupName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "resourceGroupName", valid_594136
  var valid_594137 = path.getOrDefault("subscriptionId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "subscriptionId", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_BudgetsListByResourceGroupName_594133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_BudgetsListByResourceGroupName_594133;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## budgetsListByResourceGroupName
  ## Lists all budgets for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(path_594141, "resourceGroupName", newJString(resourceGroupName))
  add(query_594142, "api-version", newJString(apiVersion))
  add(path_594141, "subscriptionId", newJString(subscriptionId))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var budgetsListByResourceGroupName* = Call_BudgetsListByResourceGroupName_594133(
    name: "budgetsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets",
    validator: validate_BudgetsListByResourceGroupName_594134, base: "",
    url: url_BudgetsListByResourceGroupName_594135, schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdateByResourceGroupName_594154 = ref object of OpenApiRestCall_593425
proc url_BudgetsCreateOrUpdateByResourceGroupName_594156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdateByResourceGroupName_594155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594157 = path.getOrDefault("resourceGroupName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "resourceGroupName", valid_594157
  var valid_594158 = path.getOrDefault("subscriptionId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "subscriptionId", valid_594158
  var valid_594159 = path.getOrDefault("budgetName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "budgetName", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
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

proc call*(call_594162: Call_BudgetsCreateOrUpdateByResourceGroupName_594154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_BudgetsCreateOrUpdateByResourceGroupName_594154;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; budgetName: string): Recallable =
  ## budgetsCreateOrUpdateByResourceGroupName
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  var body_594166 = newJObject()
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594166 = parameters
  add(path_594164, "budgetName", newJString(budgetName))
  result = call_594163.call(path_594164, query_594165, nil, nil, body_594166)

var budgetsCreateOrUpdateByResourceGroupName* = Call_BudgetsCreateOrUpdateByResourceGroupName_594154(
    name: "budgetsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdateByResourceGroupName_594155, base: "",
    url: url_BudgetsCreateOrUpdateByResourceGroupName_594156,
    schemes: {Scheme.Https})
type
  Call_BudgetsGetByResourceGroupName_594143 = ref object of OpenApiRestCall_593425
proc url_BudgetsGetByResourceGroupName_594145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGetByResourceGroupName_594144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594146 = path.getOrDefault("resourceGroupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceGroupName", valid_594146
  var valid_594147 = path.getOrDefault("subscriptionId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "subscriptionId", valid_594147
  var valid_594148 = path.getOrDefault("budgetName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "budgetName", valid_594148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "api-version", valid_594149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594150: Call_BudgetsGetByResourceGroupName_594143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_BudgetsGetByResourceGroupName_594143;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          budgetName: string): Recallable =
  ## budgetsGetByResourceGroupName
  ## Gets the budget for a resource group under a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  add(path_594152, "resourceGroupName", newJString(resourceGroupName))
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "subscriptionId", newJString(subscriptionId))
  add(path_594152, "budgetName", newJString(budgetName))
  result = call_594151.call(path_594152, query_594153, nil, nil, nil)

var budgetsGetByResourceGroupName* = Call_BudgetsGetByResourceGroupName_594143(
    name: "budgetsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsGetByResourceGroupName_594144, base: "",
    url: url_BudgetsGetByResourceGroupName_594145, schemes: {Scheme.Https})
type
  Call_BudgetsDeleteByResourceGroupName_594167 = ref object of OpenApiRestCall_593425
proc url_BudgetsDeleteByResourceGroupName_594169(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDeleteByResourceGroupName_594168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("subscriptionId")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "subscriptionId", valid_594171
  var valid_594172 = path.getOrDefault("budgetName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "budgetName", valid_594172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594173 = query.getOrDefault("api-version")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "api-version", valid_594173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594174: Call_BudgetsDeleteByResourceGroupName_594167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_BudgetsDeleteByResourceGroupName_594167;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          budgetName: string): Recallable =
  ## budgetsDeleteByResourceGroupName
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  add(path_594176, "budgetName", newJString(budgetName))
  result = call_594175.call(path_594176, query_594177, nil, nil, nil)

var budgetsDeleteByResourceGroupName* = Call_BudgetsDeleteByResourceGroupName_594167(
    name: "budgetsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDeleteByResourceGroupName_594168, base: "",
    url: url_BudgetsDeleteByResourceGroupName_594169, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
