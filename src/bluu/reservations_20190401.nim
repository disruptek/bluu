
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Reservation
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## This API describe Azure Reservation
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "reservations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReservationOrderCalculate_593660 = ref object of OpenApiRestCall_593438
proc url_ReservationOrderCalculate_593662(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReservationOrderCalculate_593661(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Calculate price for placing a `ReservationOrder`.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Information needed for calculate or purchase reservation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_ReservationOrderCalculate_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Calculate price for placing a `ReservationOrder`.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_ReservationOrderCalculate_593660; apiVersion: string;
          body: JsonNode): Recallable =
  ## reservationOrderCalculate
  ## Calculate price for placing a `ReservationOrder`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   body: JObject (required)
  ##       : Information needed for calculate or purchase reservation
  var query_593917 = newJObject()
  var body_593919 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  if body != nil:
    body_593919 = body
  result = call_593916.call(nil, query_593917, nil, nil, body_593919)

var reservationOrderCalculate* = Call_ReservationOrderCalculate_593660(
    name: "reservationOrderCalculate", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Capacity/calculatePrice",
    validator: validate_ReservationOrderCalculate_593661, base: "",
    url: url_ReservationOrderCalculate_593662, schemes: {Scheme.Https})
type
  Call_OperationList_593958 = ref object of OpenApiRestCall_593438
proc url_OperationList_593960(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationList_593959(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_OperationList_593958; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_OperationList_593958; apiVersion: string): Recallable =
  ## operationList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  result = call_593963.call(nil, query_593964, nil, nil, nil)

var operationList* = Call_OperationList_593958(name: "operationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Capacity/operations",
    validator: validate_OperationList_593959, base: "", url: url_OperationList_593960,
    schemes: {Scheme.Https})
type
  Call_ReservationOrderList_593965 = ref object of OpenApiRestCall_593438
proc url_ReservationOrderList_593967(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReservationOrderList_593966(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of all the `ReservationOrder`s that the user has access to in the current tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_ReservationOrderList_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of all the `ReservationOrder`s that the user has access to in the current tenant.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_ReservationOrderList_593965; apiVersion: string): Recallable =
  ## reservationOrderList
  ## List of all the `ReservationOrder`s that the user has access to in the current tenant.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  var query_593971 = newJObject()
  add(query_593971, "api-version", newJString(apiVersion))
  result = call_593970.call(nil, query_593971, nil, nil, nil)

var reservationOrderList* = Call_ReservationOrderList_593965(
    name: "reservationOrderList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Capacity/reservationOrders",
    validator: validate_ReservationOrderList_593966, base: "",
    url: url_ReservationOrderList_593967, schemes: {Scheme.Https})
type
  Call_ReservationOrderPurchase_593997 = ref object of OpenApiRestCall_593438
proc url_ReservationOrderPurchase_593999(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationOrderPurchase_593998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Purchase `ReservationOrder` and create resource under the specified URI.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594000 = path.getOrDefault("reservationOrderId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "reservationOrderId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Information needed for calculate or purchase reservation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_ReservationOrderPurchase_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Purchase `ReservationOrder` and create resource under the specified URI.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_ReservationOrderPurchase_593997; apiVersion: string;
          reservationOrderId: string; body: JsonNode): Recallable =
  ## reservationOrderPurchase
  ## Purchase `ReservationOrder` and create resource under the specified URI.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   body: JObject (required)
  ##       : Information needed for calculate or purchase reservation
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "reservationOrderId", newJString(reservationOrderId))
  if body != nil:
    body_594007 = body
  result = call_594004.call(path_594005, query_594006, nil, nil, body_594007)

var reservationOrderPurchase* = Call_ReservationOrderPurchase_593997(
    name: "reservationOrderPurchase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}",
    validator: validate_ReservationOrderPurchase_593998, base: "",
    url: url_ReservationOrderPurchase_593999, schemes: {Scheme.Https})
type
  Call_ReservationOrderGet_593972 = ref object of OpenApiRestCall_593438
proc url_ReservationOrderGet_593974(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationOrderGet_593973(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the details of the `ReservationOrder`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_593990 = path.getOrDefault("reservationOrderId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "reservationOrderId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  ##   $expand: JString
  ##          : May be used to expand the planInformation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  var valid_593992 = query.getOrDefault("$expand")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "$expand", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ReservationOrderGet_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the `ReservationOrder`.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ReservationOrderGet_593972; apiVersion: string;
          reservationOrderId: string; Expand: string = ""): Recallable =
  ## reservationOrderGet
  ## Get the details of the `ReservationOrder`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   Expand: string
  ##         : May be used to expand the planInformation.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(query_593996, "$expand", newJString(Expand))
  add(path_593995, "reservationOrderId", newJString(reservationOrderId))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var reservationOrderGet* = Call_ReservationOrderGet_593972(
    name: "reservationOrderGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}",
    validator: validate_ReservationOrderGet_593973, base: "",
    url: url_ReservationOrderGet_593974, schemes: {Scheme.Https})
type
  Call_ReservationMerge_594008 = ref object of OpenApiRestCall_593438
proc url_ReservationMerge_594010(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/merge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationMerge_594009(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Merge the specified `Reservation`s into a new `Reservation`. The two `Reservation`s being merged must have same properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594011 = path.getOrDefault("reservationOrderId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "reservationOrderId", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Information needed for commercial request for a reservation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_ReservationMerge_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Merge the specified `Reservation`s into a new `Reservation`. The two `Reservation`s being merged must have same properties.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_ReservationMerge_594008; apiVersion: string;
          reservationOrderId: string; body: JsonNode): Recallable =
  ## reservationMerge
  ## Merge the specified `Reservation`s into a new `Reservation`. The two `Reservation`s being merged must have same properties.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   body: JObject (required)
  ##       : Information needed for commercial request for a reservation
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "reservationOrderId", newJString(reservationOrderId))
  if body != nil:
    body_594018 = body
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var reservationMerge* = Call_ReservationMerge_594008(name: "reservationMerge",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/merge",
    validator: validate_ReservationMerge_594009, base: "",
    url: url_ReservationMerge_594010, schemes: {Scheme.Https})
type
  Call_ReservationList_594019 = ref object of OpenApiRestCall_593438
proc url_ReservationList_594021(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationList_594020(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List `Reservation`s within a single `ReservationOrder`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594022 = path.getOrDefault("reservationOrderId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "reservationOrderId", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_ReservationList_594019; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List `Reservation`s within a single `ReservationOrder`.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_ReservationList_594019; apiVersion: string;
          reservationOrderId: string): Recallable =
  ## reservationList
  ## List `Reservation`s within a single `ReservationOrder`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "reservationOrderId", newJString(reservationOrderId))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var reservationList* = Call_ReservationList_594019(name: "reservationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations",
    validator: validate_ReservationList_594020, base: "", url: url_ReservationList_594021,
    schemes: {Scheme.Https})
type
  Call_ReservationGet_594028 = ref object of OpenApiRestCall_593438
proc url_ReservationGet_594030(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationGet_594029(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get specific `Reservation` details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the Reservation Item
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594031 = path.getOrDefault("reservationOrderId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "reservationOrderId", valid_594031
  var valid_594032 = path.getOrDefault("reservationId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "reservationId", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  ##   expand: JString
  ##         : Supported value of this query is renewProperties
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  var valid_594034 = query.getOrDefault("expand")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "expand", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_ReservationGet_594028; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get specific `Reservation` details.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_ReservationGet_594028; apiVersion: string;
          reservationOrderId: string; reservationId: string; expand: string = ""): Recallable =
  ## reservationGet
  ## Get specific `Reservation` details.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   expand: string
  ##         : Supported value of this query is renewProperties
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the Reservation Item
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  add(query_594038, "expand", newJString(expand))
  add(path_594037, "reservationOrderId", newJString(reservationOrderId))
  add(path_594037, "reservationId", newJString(reservationId))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var reservationGet* = Call_ReservationGet_594028(name: "reservationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}",
    validator: validate_ReservationGet_594029, base: "", url: url_ReservationGet_594030,
    schemes: {Scheme.Https})
type
  Call_ReservationUpdate_594039 = ref object of OpenApiRestCall_593438
proc url_ReservationUpdate_594041(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationUpdate_594040(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the applied scopes of the `Reservation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the Reservation Item
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594042 = path.getOrDefault("reservationOrderId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "reservationOrderId", valid_594042
  var valid_594043 = path.getOrDefault("reservationId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "reservationId", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information needed to patch a reservation item
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_ReservationUpdate_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the applied scopes of the `Reservation`.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_ReservationUpdate_594039; apiVersion: string;
          reservationOrderId: string; reservationId: string; parameters: JsonNode): Recallable =
  ## reservationUpdate
  ## Updates the applied scopes of the `Reservation`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the Reservation Item
  ##   parameters: JObject (required)
  ##             : Information needed to patch a reservation item
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "reservationOrderId", newJString(reservationOrderId))
  add(path_594048, "reservationId", newJString(reservationId))
  if parameters != nil:
    body_594050 = parameters
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var reservationUpdate* = Call_ReservationUpdate_594039(name: "reservationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}",
    validator: validate_ReservationUpdate_594040, base: "",
    url: url_ReservationUpdate_594041, schemes: {Scheme.Https})
type
  Call_ReservationAvailableScopes_594051 = ref object of OpenApiRestCall_593438
proc url_ReservationAvailableScopes_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"),
               (kind: ConstantSegment, value: "/availableScopes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationAvailableScopes_594052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Available Scopes for `Reservation`.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the Reservation Item
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594054 = path.getOrDefault("reservationOrderId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "reservationOrderId", valid_594054
  var valid_594055 = path.getOrDefault("reservationId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "reservationId", valid_594055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594056 = query.getOrDefault("api-version")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "api-version", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JArray (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_ReservationAvailableScopes_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Available Scopes for `Reservation`.
  ## 
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_ReservationAvailableScopes_594051; apiVersion: string;
          reservationOrderId: string; reservationId: string; body: JsonNode): Recallable =
  ## reservationAvailableScopes
  ## Get Available Scopes for `Reservation`.
  ## 
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the Reservation Item
  ##   body: JArray (required)
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  var body_594062 = newJObject()
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "reservationOrderId", newJString(reservationOrderId))
  add(path_594060, "reservationId", newJString(reservationId))
  if body != nil:
    body_594062 = body
  result = call_594059.call(path_594060, query_594061, nil, nil, body_594062)

var reservationAvailableScopes* = Call_ReservationAvailableScopes_594051(
    name: "reservationAvailableScopes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}/availableScopes",
    validator: validate_ReservationAvailableScopes_594052, base: "",
    url: url_ReservationAvailableScopes_594053, schemes: {Scheme.Https})
type
  Call_ReservationListRevisions_594063 = ref object of OpenApiRestCall_593438
proc url_ReservationListRevisions_594065(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
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
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationListRevisions_594064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of all the revisions for the `Reservation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the Reservation Item
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594066 = path.getOrDefault("reservationOrderId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "reservationOrderId", valid_594066
  var valid_594067 = path.getOrDefault("reservationId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "reservationId", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_ReservationListRevisions_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of all the revisions for the `Reservation`.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_ReservationListRevisions_594063; apiVersion: string;
          reservationOrderId: string; reservationId: string): Recallable =
  ## reservationListRevisions
  ## List of all the revisions for the `Reservation`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the Reservation Item
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "reservationOrderId", newJString(reservationOrderId))
  add(path_594071, "reservationId", newJString(reservationId))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var reservationListRevisions* = Call_ReservationListRevisions_594063(
    name: "reservationListRevisions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}/revisions",
    validator: validate_ReservationListRevisions_594064, base: "",
    url: url_ReservationListRevisions_594065, schemes: {Scheme.Https})
type
  Call_ReservationSplit_594073 = ref object of OpenApiRestCall_593438
proc url_ReservationSplit_594075(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationOrders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/split")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationSplit_594074(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Split a `Reservation` into two `Reservation`s with specified quantity distribution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_594076 = path.getOrDefault("reservationOrderId")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "reservationOrderId", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Information needed to Split a reservation item
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594079: Call_ReservationSplit_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Split a `Reservation` into two `Reservation`s with specified quantity distribution.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_ReservationSplit_594073; apiVersion: string;
          reservationOrderId: string; body: JsonNode): Recallable =
  ## reservationSplit
  ## Split a `Reservation` into two `Reservation`s with specified quantity distribution.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   body: JObject (required)
  ##       : Information needed to Split a reservation item
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  var body_594083 = newJObject()
  add(query_594082, "api-version", newJString(apiVersion))
  add(path_594081, "reservationOrderId", newJString(reservationOrderId))
  if body != nil:
    body_594083 = body
  result = call_594080.call(path_594081, query_594082, nil, nil, body_594083)

var reservationSplit* = Call_ReservationSplit_594073(name: "reservationSplit",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/split",
    validator: validate_ReservationSplit_594074, base: "",
    url: url_ReservationSplit_594075, schemes: {Scheme.Https})
type
  Call_GetAppliedReservationList_594084 = ref object of OpenApiRestCall_593438
proc url_GetAppliedReservationList_594086(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Capacity/appliedReservations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetAppliedReservationList_594085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get applicable `Reservation`s that are applied to this subscription or a resource group under this subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Id of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594087 = path.getOrDefault("subscriptionId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "subscriptionId", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_GetAppliedReservationList_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get applicable `Reservation`s that are applied to this subscription or a resource group under this subscription.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_GetAppliedReservationList_594084; apiVersion: string;
          subscriptionId: string): Recallable =
  ## getAppliedReservationList
  ## Get applicable `Reservation`s that are applied to this subscription or a resource group under this subscription.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   subscriptionId: string (required)
  ##                 : Id of the subscription
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var getAppliedReservationList* = Call_GetAppliedReservationList_594084(
    name: "getAppliedReservationList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Capacity/appliedReservations",
    validator: validate_GetAppliedReservationList_594085, base: "",
    url: url_GetAppliedReservationList_594086, schemes: {Scheme.Https})
type
  Call_GetCatalog_594093 = ref object of OpenApiRestCall_593438
proc url_GetCatalog_594095(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Capacity/catalogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCatalog_594094(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Id of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  ##   reservedResourceType: JString (required)
  ##                       : The type of the resource for which the skus should be provided.
  ##   location: JString
  ##           : Filters the skus based on the location specified in this parameter. This can be an azure region or global
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  var valid_594098 = query.getOrDefault("reservedResourceType")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "reservedResourceType", valid_594098
  var valid_594099 = query.getOrDefault("location")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "location", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_GetCatalog_594093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_GetCatalog_594093; apiVersion: string;
          reservedResourceType: string; subscriptionId: string;
          location: string = ""): Recallable =
  ## getCatalog
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservedResourceType: string (required)
  ##                       : The type of the resource for which the skus should be provided.
  ##   subscriptionId: string (required)
  ##                 : Id of the subscription
  ##   location: string
  ##           : Filters the skus based on the location specified in this parameter. This can be an azure region or global
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(query_594103, "api-version", newJString(apiVersion))
  add(query_594103, "reservedResourceType", newJString(reservedResourceType))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  add(query_594103, "location", newJString(location))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var getCatalog* = Call_GetCatalog_594093(name: "getCatalog",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Capacity/catalogs",
                                      validator: validate_GetCatalog_594094,
                                      base: "", url: url_GetCatalog_594095,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
