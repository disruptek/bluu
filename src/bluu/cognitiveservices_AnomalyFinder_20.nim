
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Anomaly Finder Client
## version: 2.0
## termsOfService: (not provided)
## license: (not provided)
## 
## The Anomaly Finder API detects anomalies automatically in time series data. It supports two functionalities, one is for detecting the whole series with model trained by the timeseries, another is detecting last point with model trained by points before. By using this service, business customers can discover incidents and establish a logic flow for root cause analysis.
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
  macServiceName = "cognitiveservices-AnomalyFinder"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EntireDetect_567880 = ref object of OpenApiRestCall_567658
proc url_EntireDetect_567882(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EntireDetect_567881(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation will generate a model using the entire series, each point will be detected with the same model. In this method, points before and after a certain point will be used to determine whether it's an anomaly. The entire detection can give user an overall status of the time series.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Time series points and period if needed. Advanced model parameters can also be set in the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_EntireDetect_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation will generate a model using the entire series, each point will be detected with the same model. In this method, points before and after a certain point will be used to determine whether it's an anomaly. The entire detection can give user an overall status of the time series.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_EntireDetect_567880; body: JsonNode): Recallable =
  ## entireDetect
  ## The operation will generate a model using the entire series, each point will be detected with the same model. In this method, points before and after a certain point will be used to determine whether it's an anomaly. The entire detection can give user an overall status of the time series.
  ##   body: JObject (required)
  ##       : Time series points and period if needed. Advanced model parameters can also be set in the request.
  var body_568136 = newJObject()
  if body != nil:
    body_568136 = body
  result = call_568135.call(nil, nil, nil, nil, body_568136)

var entireDetect* = Call_EntireDetect_567880(name: "entireDetect",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/timeseries/entire/detect", validator: validate_EntireDetect_567881,
    base: "", url: url_EntireDetect_567882, schemes: {Scheme.Https})
type
  Call_LastDetect_568175 = ref object of OpenApiRestCall_567658
proc url_LastDetect_568177(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LastDetect_568176(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation will generate a model using points before the latest one, In this method, only history points are used for determine whether the target point is an anomaly. Latest point detecting matches the scenario of real-time monitoring of business metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Time series points and period if needed. Advanced model parameters can also be set in the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568179: Call_LastDetect_568175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation will generate a model using points before the latest one, In this method, only history points are used for determine whether the target point is an anomaly. Latest point detecting matches the scenario of real-time monitoring of business metrics.
  ## 
  let valid = call_568179.validator(path, query, header, formData, body)
  let scheme = call_568179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568179.url(scheme.get, call_568179.host, call_568179.base,
                         call_568179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568179, url, valid)

proc call*(call_568180: Call_LastDetect_568175; body: JsonNode): Recallable =
  ## lastDetect
  ## The operation will generate a model using points before the latest one, In this method, only history points are used for determine whether the target point is an anomaly. Latest point detecting matches the scenario of real-time monitoring of business metrics.
  ##   body: JObject (required)
  ##       : Time series points and period if needed. Advanced model parameters can also be set in the request.
  var body_568181 = newJObject()
  if body != nil:
    body_568181 = body
  result = call_568180.call(nil, nil, nil, nil, body_568181)

var lastDetect* = Call_LastDetect_568175(name: "lastDetect",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/timeseries/last/detect",
                                      validator: validate_LastDetect_568176,
                                      base: "", url: url_LastDetect_568177,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
