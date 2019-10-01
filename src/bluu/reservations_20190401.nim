
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "reservations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReservationOrderCalculate_567889 = ref object of OpenApiRestCall_567667
proc url_ReservationOrderCalculate_567891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReservationOrderCalculate_567890(path: JsonNode; query: JsonNode;
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
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
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

proc call*(call_568074: Call_ReservationOrderCalculate_567889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Calculate price for placing a `ReservationOrder`.
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_ReservationOrderCalculate_567889; apiVersion: string;
          body: JsonNode): Recallable =
  ## reservationOrderCalculate
  ## Calculate price for placing a `ReservationOrder`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   body: JObject (required)
  ##       : Information needed for calculate or purchase reservation
  var query_568146 = newJObject()
  var body_568148 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  if body != nil:
    body_568148 = body
  result = call_568145.call(nil, query_568146, nil, nil, body_568148)

var reservationOrderCalculate* = Call_ReservationOrderCalculate_567889(
    name: "reservationOrderCalculate", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Capacity/calculatePrice",
    validator: validate_ReservationOrderCalculate_567890, base: "",
    url: url_ReservationOrderCalculate_567891, schemes: {Scheme.Https})
type
  Call_OperationList_568187 = ref object of OpenApiRestCall_567667
proc url_OperationList_568189(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationList_568188(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568191: Call_OperationList_568187; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_568191.validator(path, query, header, formData, body)
  let scheme = call_568191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568191.url(scheme.get, call_568191.host, call_568191.base,
                         call_568191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568191, url, valid)

proc call*(call_568192: Call_OperationList_568187; apiVersion: string): Recallable =
  ## operationList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  var query_568193 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  result = call_568192.call(nil, query_568193, nil, nil, nil)

var operationList* = Call_OperationList_568187(name: "operationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Capacity/operations",
    validator: validate_OperationList_568188, base: "", url: url_OperationList_568189,
    schemes: {Scheme.Https})
type
  Call_ReservationOrderList_568194 = ref object of OpenApiRestCall_567667
proc url_ReservationOrderList_568196(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReservationOrderList_568195(path: JsonNode; query: JsonNode;
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
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ReservationOrderList_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of all the `ReservationOrder`s that the user has access to in the current tenant.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ReservationOrderList_568194; apiVersion: string): Recallable =
  ## reservationOrderList
  ## List of all the `ReservationOrder`s that the user has access to in the current tenant.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  var query_568200 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  result = call_568199.call(nil, query_568200, nil, nil, nil)

var reservationOrderList* = Call_ReservationOrderList_568194(
    name: "reservationOrderList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Capacity/reservationOrders",
    validator: validate_ReservationOrderList_568195, base: "",
    url: url_ReservationOrderList_568196, schemes: {Scheme.Https})
type
  Call_ReservationOrderPurchase_568226 = ref object of OpenApiRestCall_567667
proc url_ReservationOrderPurchase_568228(protocol: Scheme; host: string;
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

proc validate_ReservationOrderPurchase_568227(path: JsonNode; query: JsonNode;
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
  var valid_568229 = path.getOrDefault("reservationOrderId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "reservationOrderId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
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

proc call*(call_568232: Call_ReservationOrderPurchase_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Purchase `ReservationOrder` and create resource under the specified URI.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_ReservationOrderPurchase_568226; apiVersion: string;
          reservationOrderId: string; body: JsonNode): Recallable =
  ## reservationOrderPurchase
  ## Purchase `ReservationOrder` and create resource under the specified URI.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   body: JObject (required)
  ##       : Information needed for calculate or purchase reservation
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  var body_568236 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "reservationOrderId", newJString(reservationOrderId))
  if body != nil:
    body_568236 = body
  result = call_568233.call(path_568234, query_568235, nil, nil, body_568236)

var reservationOrderPurchase* = Call_ReservationOrderPurchase_568226(
    name: "reservationOrderPurchase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}",
    validator: validate_ReservationOrderPurchase_568227, base: "",
    url: url_ReservationOrderPurchase_568228, schemes: {Scheme.Https})
type
  Call_ReservationOrderGet_568201 = ref object of OpenApiRestCall_567667
proc url_ReservationOrderGet_568203(protocol: Scheme; host: string; base: string;
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

proc validate_ReservationOrderGet_568202(path: JsonNode; query: JsonNode;
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
  var valid_568219 = path.getOrDefault("reservationOrderId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "reservationOrderId", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  ##   $expand: JString
  ##          : May be used to expand the planInformation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  var valid_568221 = query.getOrDefault("$expand")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "$expand", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_ReservationOrderGet_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the `ReservationOrder`.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_ReservationOrderGet_568201; apiVersion: string;
          reservationOrderId: string; Expand: string = ""): Recallable =
  ## reservationOrderGet
  ## Get the details of the `ReservationOrder`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   Expand: string
  ##         : May be used to expand the planInformation.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(query_568225, "$expand", newJString(Expand))
  add(path_568224, "reservationOrderId", newJString(reservationOrderId))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var reservationOrderGet* = Call_ReservationOrderGet_568201(
    name: "reservationOrderGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}",
    validator: validate_ReservationOrderGet_568202, base: "",
    url: url_ReservationOrderGet_568203, schemes: {Scheme.Https})
type
  Call_ReservationMerge_568237 = ref object of OpenApiRestCall_567667
proc url_ReservationMerge_568239(protocol: Scheme; host: string; base: string;
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

proc validate_ReservationMerge_568238(path: JsonNode; query: JsonNode;
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
  var valid_568240 = path.getOrDefault("reservationOrderId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "reservationOrderId", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
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

proc call*(call_568243: Call_ReservationMerge_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Merge the specified `Reservation`s into a new `Reservation`. The two `Reservation`s being merged must have same properties.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_ReservationMerge_568237; apiVersion: string;
          reservationOrderId: string; body: JsonNode): Recallable =
  ## reservationMerge
  ## Merge the specified `Reservation`s into a new `Reservation`. The two `Reservation`s being merged must have same properties.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   body: JObject (required)
  ##       : Information needed for commercial request for a reservation
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "reservationOrderId", newJString(reservationOrderId))
  if body != nil:
    body_568247 = body
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var reservationMerge* = Call_ReservationMerge_568237(name: "reservationMerge",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/merge",
    validator: validate_ReservationMerge_568238, base: "",
    url: url_ReservationMerge_568239, schemes: {Scheme.Https})
type
  Call_ReservationList_568248 = ref object of OpenApiRestCall_567667
proc url_ReservationList_568250(protocol: Scheme; host: string; base: string;
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

proc validate_ReservationList_568249(path: JsonNode; query: JsonNode;
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
  var valid_568251 = path.getOrDefault("reservationOrderId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "reservationOrderId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
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

proc call*(call_568253: Call_ReservationList_568248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List `Reservation`s within a single `ReservationOrder`.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_ReservationList_568248; apiVersion: string;
          reservationOrderId: string): Recallable =
  ## reservationList
  ## List `Reservation`s within a single `ReservationOrder`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "reservationOrderId", newJString(reservationOrderId))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var reservationList* = Call_ReservationList_568248(name: "reservationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations",
    validator: validate_ReservationList_568249, base: "", url: url_ReservationList_568250,
    schemes: {Scheme.Https})
type
  Call_ReservationGet_568257 = ref object of OpenApiRestCall_567667
proc url_ReservationGet_568259(protocol: Scheme; host: string; base: string;
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

proc validate_ReservationGet_568258(path: JsonNode; query: JsonNode;
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
  var valid_568260 = path.getOrDefault("reservationOrderId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "reservationOrderId", valid_568260
  var valid_568261 = path.getOrDefault("reservationId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "reservationId", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  ##   expand: JString
  ##         : Supported value of this query is renewProperties
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  var valid_568263 = query.getOrDefault("expand")
  valid_568263 = validateParameter(valid_568263, JString, required = false,
                                 default = nil)
  if valid_568263 != nil:
    section.add "expand", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_ReservationGet_568257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get specific `Reservation` details.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_ReservationGet_568257; apiVersion: string;
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
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(query_568267, "api-version", newJString(apiVersion))
  add(query_568267, "expand", newJString(expand))
  add(path_568266, "reservationOrderId", newJString(reservationOrderId))
  add(path_568266, "reservationId", newJString(reservationId))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var reservationGet* = Call_ReservationGet_568257(name: "reservationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}",
    validator: validate_ReservationGet_568258, base: "", url: url_ReservationGet_568259,
    schemes: {Scheme.Https})
type
  Call_ReservationUpdate_568268 = ref object of OpenApiRestCall_567667
proc url_ReservationUpdate_568270(protocol: Scheme; host: string; base: string;
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

proc validate_ReservationUpdate_568269(path: JsonNode; query: JsonNode;
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
  var valid_568271 = path.getOrDefault("reservationOrderId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "reservationOrderId", valid_568271
  var valid_568272 = path.getOrDefault("reservationId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "reservationId", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information needed to patch a reservation item
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_ReservationUpdate_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the applied scopes of the `Reservation`.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_ReservationUpdate_568268; apiVersion: string;
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
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "reservationOrderId", newJString(reservationOrderId))
  add(path_568277, "reservationId", newJString(reservationId))
  if parameters != nil:
    body_568279 = parameters
  result = call_568276.call(path_568277, query_568278, nil, nil, body_568279)

var reservationUpdate* = Call_ReservationUpdate_568268(name: "reservationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}",
    validator: validate_ReservationUpdate_568269, base: "",
    url: url_ReservationUpdate_568270, schemes: {Scheme.Https})
type
  Call_ReservationAvailableScopes_568280 = ref object of OpenApiRestCall_567667
proc url_ReservationAvailableScopes_568282(protocol: Scheme; host: string;
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

proc validate_ReservationAvailableScopes_568281(path: JsonNode; query: JsonNode;
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
  var valid_568283 = path.getOrDefault("reservationOrderId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "reservationOrderId", valid_568283
  var valid_568284 = path.getOrDefault("reservationId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "reservationId", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
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

proc call*(call_568287: Call_ReservationAvailableScopes_568280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Available Scopes for `Reservation`.
  ## 
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_ReservationAvailableScopes_568280; apiVersion: string;
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
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  var body_568291 = newJObject()
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "reservationOrderId", newJString(reservationOrderId))
  add(path_568289, "reservationId", newJString(reservationId))
  if body != nil:
    body_568291 = body
  result = call_568288.call(path_568289, query_568290, nil, nil, body_568291)

var reservationAvailableScopes* = Call_ReservationAvailableScopes_568280(
    name: "reservationAvailableScopes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}/availableScopes",
    validator: validate_ReservationAvailableScopes_568281, base: "",
    url: url_ReservationAvailableScopes_568282, schemes: {Scheme.Https})
type
  Call_ReservationListRevisions_568292 = ref object of OpenApiRestCall_567667
proc url_ReservationListRevisions_568294(protocol: Scheme; host: string;
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

proc validate_ReservationListRevisions_568293(path: JsonNode; query: JsonNode;
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
  var valid_568295 = path.getOrDefault("reservationOrderId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "reservationOrderId", valid_568295
  var valid_568296 = path.getOrDefault("reservationId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "reservationId", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
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

proc call*(call_568298: Call_ReservationListRevisions_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of all the revisions for the `Reservation`.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_ReservationListRevisions_568292; apiVersion: string;
          reservationOrderId: string; reservationId: string): Recallable =
  ## reservationListRevisions
  ## List of all the revisions for the `Reservation`.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the Reservation Item
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "reservationOrderId", newJString(reservationOrderId))
  add(path_568300, "reservationId", newJString(reservationId))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var reservationListRevisions* = Call_ReservationListRevisions_568292(
    name: "reservationListRevisions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/reservations/{reservationId}/revisions",
    validator: validate_ReservationListRevisions_568293, base: "",
    url: url_ReservationListRevisions_568294, schemes: {Scheme.Https})
type
  Call_ReservationSplit_568302 = ref object of OpenApiRestCall_567667
proc url_ReservationSplit_568304(protocol: Scheme; host: string; base: string;
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

proc validate_ReservationSplit_568303(path: JsonNode; query: JsonNode;
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
  var valid_568305 = path.getOrDefault("reservationOrderId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "reservationOrderId", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
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
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Information needed to Split a reservation item
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_ReservationSplit_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Split a `Reservation` into two `Reservation`s with specified quantity distribution.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_ReservationSplit_568302; apiVersion: string;
          reservationOrderId: string; body: JsonNode): Recallable =
  ## reservationSplit
  ## Split a `Reservation` into two `Reservation`s with specified quantity distribution.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   body: JObject (required)
  ##       : Information needed to Split a reservation item
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  var body_568312 = newJObject()
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "reservationOrderId", newJString(reservationOrderId))
  if body != nil:
    body_568312 = body
  result = call_568309.call(path_568310, query_568311, nil, nil, body_568312)

var reservationSplit* = Call_ReservationSplit_568302(name: "reservationSplit",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationOrders/{reservationOrderId}/split",
    validator: validate_ReservationSplit_568303, base: "",
    url: url_ReservationSplit_568304, schemes: {Scheme.Https})
type
  Call_GetAppliedReservationList_568313 = ref object of OpenApiRestCall_567667
proc url_GetAppliedReservationList_568315(protocol: Scheme; host: string;
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

proc validate_GetAppliedReservationList_568314(path: JsonNode; query: JsonNode;
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
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version for this document is 2019-04-01
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
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_GetAppliedReservationList_568313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get applicable `Reservation`s that are applied to this subscription or a resource group under this subscription.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_GetAppliedReservationList_568313; apiVersion: string;
          subscriptionId: string): Recallable =
  ## getAppliedReservationList
  ## Get applicable `Reservation`s that are applied to this subscription or a resource group under this subscription.
  ##   apiVersion: string (required)
  ##             : Supported version for this document is 2019-04-01
  ##   subscriptionId: string (required)
  ##                 : Id of the subscription
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var getAppliedReservationList* = Call_GetAppliedReservationList_568313(
    name: "getAppliedReservationList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Capacity/appliedReservations",
    validator: validate_GetAppliedReservationList_568314, base: "",
    url: url_GetAppliedReservationList_568315, schemes: {Scheme.Https})
type
  Call_GetCatalog_568322 = ref object of OpenApiRestCall_567667
proc url_GetCatalog_568324(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetCatalog_568323(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Id of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568325 = path.getOrDefault("subscriptionId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "subscriptionId", valid_568325
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
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  var valid_568327 = query.getOrDefault("reservedResourceType")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "reservedResourceType", valid_568327
  var valid_568328 = query.getOrDefault("location")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "location", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_GetCatalog_568322; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_GetCatalog_568322; apiVersion: string;
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
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(query_568332, "api-version", newJString(apiVersion))
  add(query_568332, "reservedResourceType", newJString(reservedResourceType))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  add(query_568332, "location", newJString(location))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var getCatalog* = Call_GetCatalog_568322(name: "getCatalog",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Capacity/catalogs",
                                      validator: validate_GetCatalog_568323,
                                      base: "", url: url_GetCatalog_568324,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
